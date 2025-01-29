class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|

      t.string :title
      t.text :content
      t.boolean :is_public
      

      t.references :user, null: false, foreign_key: true
      #Ex:- :null => false
      t.timestamps
    end
  end
end
