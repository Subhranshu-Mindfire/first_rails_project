class AddDefaultToPost < ActiveRecord::Migration[7.2]
  def change
    change_column_default :posts, :is_public, true
  end
end
