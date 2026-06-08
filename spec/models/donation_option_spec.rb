require "rails_helper"

RSpec.describe DonationOption, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      expect(build(:donation_option)).to be_valid
    end

    it "requires an amount" do
      expect(build(:donation_option, amount: nil)).not_to be_valid
    end

    it "requires the amount to be greater than zero" do
      expect(build(:donation_option, amount: 0)).not_to be_valid
    end

    it "requires a label" do
      expect(build(:donation_option, label: nil)).not_to be_valid
    end
  end

  describe "associations" do
    it "belongs to a campaign" do
      campaign = create(:campaign)
      option = create(:donation_option, campaign: campaign)

      expect(option.campaign).to eq(campaign)
    end
  end

  describe "featured flag" do
    it "defaults to false" do
      expect(DonationOption.new.featured).to eq(false)
    end

    it "can be flagged as featured" do
      option = create(:donation_option, featured: true)

      expect(option).to be_featured
    end
  end
end
