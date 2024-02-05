# This migration creates the admins table.
class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :full_name
      t.integer :admin_level

      t.timestamps
    end
  end
end
