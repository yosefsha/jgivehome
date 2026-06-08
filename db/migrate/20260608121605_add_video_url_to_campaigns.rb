class AddVideoUrlToCampaigns < ActiveRecord::Migration[8.1]
  def change
    add_column :campaigns, :video_url, :string
  end
end
