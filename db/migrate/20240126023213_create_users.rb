# This migration creates the users table.
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :role, null: false, default: 'buyer'

      t.timestamps
    end
  end
end
