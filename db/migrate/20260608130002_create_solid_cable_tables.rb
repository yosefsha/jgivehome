class CreateSolidCableTables < ActiveRecord::Migration[8.1]
  def change
    # Drop-and-recreate rather than detect-and-skip — see the comment in
    # 20260608130000_create_solid_cache_tables.rb for why (ADR-001).
    drop_table :solid_cable_messages, if_exists: true

    create_table :solid_cable_messages do |t|
      t.binary :channel, limit: 1024, null: false
      t.binary :payload, limit: 536870912, null: false
      t.datetime :created_at, null: false
      t.integer :channel_hash, limit: 8, null: false

      t.index :channel
      t.index :channel_hash
      t.index :created_at
    end
  end
end
