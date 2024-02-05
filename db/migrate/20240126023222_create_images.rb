# This migration creates the images table to store image data.
class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references :product
      t.string :url

      t.timestamps
    end
    add_index :images, :product_id
  end
end
