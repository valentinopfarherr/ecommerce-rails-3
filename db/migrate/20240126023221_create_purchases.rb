# This migration creates the purchases table.
class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.references :product, index: true
      t.references :buyer, index: true
      t.datetime :purchase_date

      t.timestamps
    end
  end
end
