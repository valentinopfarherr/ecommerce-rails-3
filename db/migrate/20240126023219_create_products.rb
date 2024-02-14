# This migration creates the products table.
class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price, scale: 2
      t.boolean :first_purchase_email_sent, default: false
      t.references :creator, index: true, foreign_key: { to_table: :admin }

      t.timestamps
    end
  end
end
