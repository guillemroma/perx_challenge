class CreateRewards < ActiveRecord::Migration[6.1]
  def change
    create_table :rewards do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :free_coffee
      t.boolean :cash_rebate
      t.boolean :free_movie_tickets
      t.boolean :airport_lounge_access

      t.timestamps
    end
  end
end
