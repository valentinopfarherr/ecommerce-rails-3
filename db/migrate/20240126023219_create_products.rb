# This migration creates the products table.
class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.references :creator, foreign_key: { to_table: :admin }

      t.timestamps
    end
    add_index :products, :creator_id
  end
end
