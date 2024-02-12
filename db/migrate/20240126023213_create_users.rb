# This migration creates the users table.
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.string :password
      t.string :role, null: false, default: 'buyer'

      t.timestamps
    end
  end
end
