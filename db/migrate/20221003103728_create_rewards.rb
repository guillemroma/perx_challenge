class CreateRewards < ActiveRecord::Migration[6.1]
  def change
    create_table :rewards do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :free_coffee, default: false
      t.boolean :cash_rebate, default: false
      t.boolean :free_movie_tickets, default: false
      t.boolean :airport_lounge_access, default: false

      t.timestamps
    end
  end
end
