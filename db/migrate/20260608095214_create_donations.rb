class CreateDonations < ActiveRecord::Migration[8.1]
  def change
    create_table :donations do |t|
      t.references :campaign, null: false, foreign_key: true
      t.decimal :amount, precision: 12, scale: 2
      t.integer :frequency, default: 0, null: false
      t.integer :status, default: 0, null: false
      t.string :donor_name
      t.string :donor_email
      t.integer :display_preference, default: 0, null: false
      t.text :dedication_message

      t.timestamps
    end
  end
end
