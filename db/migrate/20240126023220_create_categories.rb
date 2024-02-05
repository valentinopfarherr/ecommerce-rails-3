# This migration creates the categories table.
class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.references :creator, foreign_key: { to_table: :admin }

      t.timestamps
    end
    add_index :categories, :creator_id
  end
end
