class CreateAirportLoungeControls < ActiveRecord::Migration[6.1]
  def change
    create_table :airport_lounge_controls do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :remaining

      t.timestamps
    end
  end
end
