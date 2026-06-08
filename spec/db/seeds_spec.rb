require "rails_helper"

RSpec.describe "db:seed" do
  it "runs cleanly and produces the expected campaign/donation counts" do
    load Rails.root.join("db/seeds.rb")

    expect(Campaign.count).to eq(2)
    expect(DonationOption.count).to eq(8)
    expect(Donation.count).to eq(10)

    expect(Campaign.exists?(slug: "orange-garden")).to be true
    expect(Campaign.exists?(slug: "neighborhood-library")).to be true
  end
end
