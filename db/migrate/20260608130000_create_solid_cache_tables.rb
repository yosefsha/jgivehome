class CreateSolidCacheTables < ActiveRecord::Migration[8.1]
  def change
    # The production database already had a `solid_cache_entries` table from an
    # earlier deploy (before the single-database consolidation in ADR-001), with
    # an unknown/possibly-stale schema. It's pure cache data — safe to drop and
    # recreate fresh rather than detect and reconcile its existing shape.
    drop_table :solid_cache_entries, if_exists: true

    create_table :solid_cache_entries do |t|
      t.binary :key, limit: 1024, null: false
      t.binary :value, limit: 536870912, null: false
      t.datetime :created_at, null: false
      t.integer :key_hash, limit: 8, null: false
      t.integer :byte_size, limit: 4, null: false

      t.index :byte_size
      t.index [ :key_hash, :byte_size ]
      t.index :key_hash, unique: true
    end
  end
end
