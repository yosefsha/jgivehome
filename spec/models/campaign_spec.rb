require "rails_helper"

RSpec.describe Campaign, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      expect(build(:campaign)).to be_valid
    end

    it "requires a title" do
      expect(build(:campaign, title: nil)).not_to be_valid
    end

    it "requires a story" do
      expect(build(:campaign, story: nil)).not_to be_valid
    end

    it "requires a goal_amount" do
      expect(build(:campaign, goal_amount: nil)).not_to be_valid
    end

    it "requires goal_amount to be greater than zero" do
      expect(build(:campaign, goal_amount: 0)).not_to be_valid
    end

    it "requires a unique slug" do
      create(:campaign, slug: "orange-garden")

      expect(build(:campaign, slug: "orange-garden")).not_to be_valid
    end
  end

  describe "associations" do
    it "destroys its donation_options when destroyed" do
      campaign = create(:campaign)
      option = create(:donation_option, campaign: campaign)

      campaign.destroy

      expect(DonationOption.exists?(option.id)).to be false
    end

    it "destroys its donations when destroyed" do
      campaign = create(:campaign)
      donation = create(:donation, campaign: campaign)

      campaign.destroy

      expect(Donation.exists?(donation.id)).to be false
    end
  end

  describe "#raised_amount" do
    let(:campaign) { create(:campaign, goal_amount: 1000) }

    it "sums pending and paid donations, but not cancelled ones" do
      create(:donation, campaign: campaign, amount: 100, status: :pending)
      create(:donation, campaign: campaign, amount: 250, status: :paid)
      create(:donation, campaign: campaign, amount: 999, status: :cancelled)

      expect(campaign.raised_amount).to eq(350)
    end

    it "counts pending donations toward the total (no payment integration exists in this demo)" do
      create(:donation, campaign: campaign, amount: 400, status: :pending)

      expect(campaign.raised_amount).to eq(400)
    end
  end

  describe "#progress_percentage" do
    let(:campaign) { create(:campaign, goal_amount: 1000) }

    it "expresses raised_amount as a percentage of the goal" do
      create(:donation, campaign: campaign, amount: 250, status: :pending)

      expect(campaign.progress_percentage).to eq(25.0)
    end

    it "counts pending donations toward progress so the bar visibly moves" do
      create(:donation, campaign: campaign, amount: 100, status: :pending)

      expect(campaign.progress_percentage).to eq(10.0)
    end
  end
end
