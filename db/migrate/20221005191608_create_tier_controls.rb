class CreateTierControls < ActiveRecord::Migration[6.1]
  def change
    create_table :tier_controls do |t|
      t.references :user, null: false, foreign_key: true
      t.string :current_year
      t.string :last_year

      t.timestamps
    end
  end
end
