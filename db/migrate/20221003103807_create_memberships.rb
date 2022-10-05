class CreateMemberships < ActiveRecord::Migration[6.1]
  def change
    create_table :memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :standard, default: true
      t.boolean :gold, default: false
      t.boolean :platinium, default: false

      t.timestamps
    end
  end
end
