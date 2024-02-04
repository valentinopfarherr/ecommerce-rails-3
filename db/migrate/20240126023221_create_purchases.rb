class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.references :product
      t.references :user
      t.datetime :purchase_date

      t.timestamps
    end
    add_index :purchases, :product_id
    add_index :purchases, :user_id
  end
end
