# This migration creates the `versions` table, the only schema PT requires.
# All other migrations PT provides are optional.
class CreateVersions < ActiveRecord::Migration
  MYSQL_ADAPTERS = [
    'ActiveRecord::ConnectionAdapters::MysqlAdapter',
    'ActiveRecord::ConnectionAdapters::Mysql2Adapter'
  ].freeze

  def change
    create_table :versions, versions_table_options do |t|
      t.string   :item_type, null: false
      t.integer  :item_id,   null: false
      t.string   :event,     null: false
      t.string   :whodunnit
      t.text     :object

      t.datetime :created_at
    end
    add_index :versions, [:item_type, :item_id]
  end

  private

  def versions_table_options
    if MYSQL_ADAPTERS.include?(connection.class.name)
      { options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci' }
    else
      {}
    end
  end
end
