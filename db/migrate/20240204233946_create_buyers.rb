# This migration creates the buyers table.
class CreateBuyers < ActiveRecord::Migration
  def change
    create_table :buyers do |t|
      t.string :full_name
      t.string :address
      t.string :phone_number

      t.timestamps
    end
  end
end
