class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name, null: false 
      t.text :description
      t.string :address
      t.float :lat, null: false
      t.float :lng, null: false 
      t.string :keywords
      t.string :images
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
