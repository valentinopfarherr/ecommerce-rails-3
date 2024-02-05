# This migration creates the purchases table.
class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.references :product
      t.references :buyer
      t.datetime :purchase_date

      t.timestamps
    end
    add_index :purchases, :product_id
    add_index :purchases, :buyer_id
  end
end
