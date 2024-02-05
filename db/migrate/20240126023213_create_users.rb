# This migration creates the users table.
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.string :password, null: false
      t.references :userable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
