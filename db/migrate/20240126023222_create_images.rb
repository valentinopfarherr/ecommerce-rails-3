# This migration creates the images table to store image data.
class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references :product, index: true
      t.string :url

      t.timestamps
    end
  end
end
