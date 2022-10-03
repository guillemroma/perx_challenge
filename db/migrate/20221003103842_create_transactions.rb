class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.float :amount
      t.string :country
      t.datetime :date

      t.timestamps
    end
  end
end
