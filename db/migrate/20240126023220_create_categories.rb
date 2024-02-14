# This migration creates the categories table.
class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.references :creator, index: true, foreign_key: { to_table: :admin }

      t.timestamps
    end
  end
end
