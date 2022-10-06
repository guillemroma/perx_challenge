class CreateRewardElegibles < ActiveRecord::Migration[6.1]
  def change
    create_table :reward_elegibles do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :free_coffee, default: true
      t.boolean :cash_rebate, default: true
      t.boolean :free_movie_tickets, default: true
      t.boolean :airport_lounge_access, default: true

      t.timestamps
    end
  end
end
