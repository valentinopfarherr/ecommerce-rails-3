# This migration creates the purchases table.
class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.references :product, index: true
      t.references :customer, index: true, foreign_key: { to_table: :users }
      t.integer :quantity
      t.decimal :total_price, scale: 2
      t.datetime :purchase_date

      t.timestamps
    end
  end
end
