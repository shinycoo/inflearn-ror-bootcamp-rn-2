class CreateUserSessions < ActiveRecord::Migration
  def change
    create_table :user_sessions do |t|
      t.references :user, index: true, foreign_key: true
      t.string :session_token
      t.string :oauth_token
      t.boolean :active

      t.timestamps null: false
    end
  end
end
