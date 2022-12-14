class YearlyRefresh
  include Modules::RecordFinder

  attr_reader :current_year

  def initialize
    @current_year = Date.today.year
  end

  def call
    @clients = select_all_clients
    true if point_refresh_and_membership_update
  end

  private

  def select_all_clients
    User.clients
  end

  def point_refresh_and_membership_update
    reset_client_points_records_and_elegibility

    @clients.each do |client|
      update_point_records(client)
      update_loyalty_tier(client)
      update_rewards(client)
    end
  end

  def update_point_records(client)
    client_points = create_or_find_one_record(Point, client)
    create_or_find_many_records(PointRecord, client, current_year, client_points.amount)
    reset_client_points(client_points)
  end

  def reset_client_points(client_points)
    client_points.amount = 0
    client_points.save!
  end

  def update_loyalty_tier(client)
    if create_or_find_many_records(PointRecord, client, current_year).maximum(:amount) > 5_000
      update_membership_records(client, :platinium)
    elsif create_or_find_many_records(PointRecord, client, current_year).maximum(:amount) > 1_000
      update_membership_records(client, :gold)
    else
      update_membership_records(client, :standard)
    end
  end

  def update_membership_records(client, membership_type)
    membership = create_or_find_one_record(Membership, client)
    Membership::MEMBERSHIP_TYPES.each do |m_type|
      if m_type == membership_type
        membership[m_type] = true
      else
        membership[m_type] = false
      end
    end
    update_tier_control(client, membership_type)
    membership.save!
  end

  def update_tier_control(client, membership_type)
    client_tier = create_or_find_one_record(TierControl, client)

    client_tier.last_year = client_tier.current_year
    client_tier.current_year = membership_type

    client_tier.save!
  end

  def update_rewards(client)
    client_rewards = create_or_find_one_record(Reward, client)
    update_airport_lounge_access_reward(client, client_rewards) if tier_turned_into_gold(client)
    false
  end

  def tier_turned_into_gold(client)
    user_tier_control = create_or_find_one_record(TierControl, client)
    user_tier_control&.current_year == "gold" && user_tier_control&.last_year == "standard"
  end

  def update_airport_lounge_access_reward(client, client_rewards)
    airport_lounge = create_or_find_one_record(AirportLoungeControl, client)

    client_rewards.airport_lounge_access = true
    airport_lounge.remaining = 4

    airport_lounge.save!
    client_rewards.save!
  end

  def reset_client_points_records_and_elegibility
    PointRecord.where.not(year: [current_year, current_year - 1]).destroy_all
    RewardElegible.all.update_all(
      free_coffee: true,
      cash_rebate: true,
      airport_lounge_access: true
    )
  end
end
