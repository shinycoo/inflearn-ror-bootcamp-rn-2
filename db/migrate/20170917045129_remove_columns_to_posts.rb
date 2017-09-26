class RemoveColumnsToPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :lat 
    remove_column :posts, :lng
    remove_column :posts, :address
    
    add_column :posts, :ratings, :float 
    add_column :posts, :image, :string 
    
    add_reference :posts, :restaurant, index: true 
  end
end
