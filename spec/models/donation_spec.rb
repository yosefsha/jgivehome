require "rails_helper"

RSpec.describe Donation, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      expect(build(:donation)).to be_valid
    end

    it "requires an amount" do
      expect(build(:donation, amount: nil)).not_to be_valid
    end

    it "requires the amount to be greater than zero" do
      expect(build(:donation, amount: 0)).not_to be_valid
    end

    it "requires a donor_name" do
      expect(build(:donation, donor_name: nil)).not_to be_valid
    end

    it "requires a donor_email" do
      expect(build(:donation, donor_email: nil)).not_to be_valid
    end

    it "requires donor_email to look like an email address" do
      expect(build(:donation, donor_email: "not-an-email")).not_to be_valid
    end
  end

  describe "associations" do
    it "belongs to a campaign" do
      campaign = create(:campaign)
      donation = create(:donation, campaign: campaign)

      expect(donation.campaign).to eq(campaign)
    end
  end

  describe "enums" do
    it "exposes frequency as one_time/monthly" do
      expect(Donation.frequencies.keys).to contain_exactly("one_time", "monthly")
      expect(build(:donation, frequency: :monthly)).to be_monthly
    end

    it "exposes status as pending/paid/cancelled, defaulting to pending" do
      expect(Donation.statuses.keys).to contain_exactly("pending", "paid", "cancelled")
      expect(Donation.new.status).to eq("pending")
    end

    it "exposes display_preference as full_name/first_name/anonymous" do
      expect(Donation.display_preferences.keys).to contain_exactly("full_name", "first_name", "anonymous")
      expect(build(:donation, display_preference: :anonymous)).to be_anonymous
    end
  end
end
