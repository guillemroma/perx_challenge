class CreatePoints < ActiveRecord::Migration[6.1]
  def change
    create_table :points do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :amount_prior_month, default: 0, limit: 8
      t.integer :amount, default: 0, limit: 8

      t.timestamps
    end
  end
end
