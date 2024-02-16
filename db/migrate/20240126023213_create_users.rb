# This migration creates the users table.
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false, unique: true
      t.string :password_digest, null: false
      t.string :role, null: false, default: 'buyer'

      t.timestamps
    end
  end
end
