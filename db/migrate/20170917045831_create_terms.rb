class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.string :title, null: false 
      t.text :contents

      t.timestamps null: false
    end
  end
end
