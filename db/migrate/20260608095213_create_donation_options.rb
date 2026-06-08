class CreateDonationOptions < ActiveRecord::Migration[8.1]
  def change
    create_table :donation_options do |t|
      t.references :campaign, null: false, foreign_key: true
      t.decimal :amount, precision: 12, scale: 2
      t.string :label
      t.boolean :featured, default: false, null: false

      t.timestamps
    end
  end
end
