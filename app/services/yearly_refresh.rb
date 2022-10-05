class YearlyRefresh
  include Modules::FindRewards

  def initialize
  end

  def call
    @current_year = Date.today.year
    @clients = select_all_clients
    point_refresh_and_membership_update
  end

  private

  def select_all_clients
    User.clients
  end

  def point_refresh_and_membership_update
    @clients.each do |client|
      update_point_records(client)
      update_loyalty_tier(client)
      update_client_rewards(client)
    end

    reset_client_points_records_and_tier_control
  end

  def update_point_records(client)
    @client_points = find_record(Point, client)
    PointRecord.create!(user: client, amount: @client_points.amount, year: @current_year)

    reset_client_points(@client_points)
  end

  def reset_client_points(client_points)
    client_points.amount = 0
    client_points.save!
  end

  def update_loyalty_tier(client)
    if client_points_records(client).maximum(:amount) > 1_000
      update_membership(client, :gold)
    elsif client_points_records(client).maximum(:amount) > 5_000
      update_membership(client, :platinium)
    else
      update_membership(client, :standard)
    end
  end

  def client_points_records(client)
    if find_points_records(client).present?
      PointRecord.where(user_id: client.id)
    else
      PointRecord.create!(user_id: client.id, amount: 0, year: @current_year)
    end
  end

  def find_points_records(client)
    PointRecord.where(user_id: client.id)
  end

  def update_membership(client, membership_type)
    update_membership_records(client, membership_type)
  end

  def update_membership_records(client, membership_type)
    membership = find_record(Membership, client)
    Membership::MEMBERHSIP_TYPES.each do |m_type|
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
    client_tier = find_record(TierControl, client)

    client_tier.last_year = client_tier.current_year
    client_tier.current_year = membership_type

    client_tier.save!
  end

  def update_client_rewards(client)
    @client_rewards = find_record(Reward, client)
    update_rewards(client, @client_rewards)
  end

  def find_record(model, client)
    if record_created?(model, client)
      model.find_by(user_id: client.id)
    else
      model.create!(user_id: client.id)
    end
  end

  def record_created?(model, client)
    model.find_by(user_id: client.id)
  end

  def update_rewards(client, client_rewards)
    update_airport_lounge_access_reward(client_rewards) if tier_turned_into_gold(client)
  end

  def tier_turned_into_gold(client)
    user_tier_control = find_record(TierControl, client)
    user_tier_control&.current_year == "gold" && user_tier_control&.last_year == "standard"
  end

  def update_airport_lounge_access_reward(client_rewards)
    client_rewards.airport_lounge_access = true
    client_rewards.save!
  end

  def reset_client_points_records_and_tier_control
    PointRecord.where.not(year: [@current_year, @current_year - 1]).destroy_all
    TierControl.where.not(year: [@current_year, @current_year - 1]).destroy_all
  end
end
