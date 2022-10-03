class AddColumnsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :country, :string
    add_column :users, :type, :string
    add_column :users, :birthday, :date
  end
end
