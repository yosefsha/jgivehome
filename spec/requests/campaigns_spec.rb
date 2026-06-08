require "rails_helper"

RSpec.describe "Campaigns", type: :request do
  describe "GET /campaigns/:slug" do
    let(:campaign) { create(:campaign, title: "הגן הכתום", slug: "orange-garden", goal_amount: 1000) }

    before do
      create(:donation, campaign: campaign, amount: 250, status: :pending)
      create(:donation, campaign: campaign, amount: 150, status: :paid)
    end

    it "renders the campaign's title, raised amount, goal, and progress" do
      get campaign_path(campaign.slug)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(campaign.title)
      expect(response.body).to include("400") # raised_amount: 250 pending + 150 paid
      expect(response.body).to include("1,000") # goal_amount
      expect(response.body).to include("40.0%") # progress_percentage
    end

    it "returns 404 for an unknown slug" do
      get campaign_path("does-not-exist")

      expect(response).to have_http_status(:not_found)
    end
  end
end
