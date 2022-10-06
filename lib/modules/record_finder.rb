module Modules
  module RecordFinder
    def create_or_find_one_record(model, client)
      if record_created?(model, client)
        model.find_by(user_id: client.id)
      else
        model.create!(user_id: client.id)
      end
    end

    def record_created?(model, client)
      model.find_by(user_id: client.id)
    end

    def create_or_find_many_records(model, client, year = 0, amount = 0)
      return model.where(user_id: client.id) if records_created?(model, client)

      if model == PointRecord
        model.create!(user_id: client.id, amount: amount, year: year)
      elsif model == Transaction
        model.create!(user_id: client.id, amount: amount, country: client.country, date: Date.today)
      else
        model.create!(user_id: client.id)
      end

      return model.where(user_id: client.id)
    end

    def records_created?(model, client)
      model.find_by(user_id: client.id)
    end
  end
end
