class CreatePoints < ActiveRecord::Migration[6.1]
  def change
    create_table :points do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :amount_prior_month
      t.integer :amount_prior_quarter
      t.integer :amount

      t.timestamps
    end
  end
end
