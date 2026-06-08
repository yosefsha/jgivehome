class CreateCampaigns < ActiveRecord::Migration[8.1]
  def change
    create_table :campaigns do |t|
      t.string :title
      t.text :story
      t.string :cover_image_url
      t.decimal :goal_amount, precision: 12, scale: 2
      t.string :slug

      t.timestamps
    end
    add_index :campaigns, :slug, unique: true
  end
end
