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
      update_reward(client)

    end

    reset_client_points_records
  end

  def update_point_records(client)
    @client_points = find_client_points(client)
    PointRecord.create!(user: client, amount: @client_points.amount, year: @current_year)

    reset_client_points(@client_points)
  end

  def find_client_points(client)
    if find_points(client).present?
      Point.find_by(user_id: client.id)
    else
      Point.create!(user_id: client.id, amount: 0)
    end
  end

  def find_points(client)
    Point.find_by(user_id: client.id)
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
    case membership_type
    when :gold
      update_membership_records(client, membership_type)
    when :platinium
      update_membership_records(client, membership_type)
    when :standard
      update_membership_records(client, membership_type)
    end
  end

  def client_membership(client)
    if find_membership(client).present?
      Membership.find_by(user_id: client.id)
    else
      Membership.create!(user_id: client.id)
    end
  end

  def find_membership(client)
    Membership.find_by(user_id: client.id)
  end

  def update_membership_records(client, membership_type)
    membership = client_membership(client)
    Membership::MEMBERHSIP_TYPES.each do |m_type|
      if m_type == membership_type
        membership[m_type] = true
      else
        membership[m_type] = false
      end
    end

    membership.save!
  end

  def reset_client_points_records
    PointRecord.where.not(year: [@current_year, @current_year - 1]).destroy_all
  end
end
