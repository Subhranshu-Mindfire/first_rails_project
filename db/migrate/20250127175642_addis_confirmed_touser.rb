class AddisConfirmedTouser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :is_confirmed, :boolean, default: false, null: false
  end
end
