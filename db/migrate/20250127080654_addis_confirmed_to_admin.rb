class AddisConfirmedToAdmin < ActiveRecord::Migration[7.2]
  def change
    add_column :admins, :is_confirmed, :boolean, default: false, null: false
  end
end
