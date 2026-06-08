require "rails_helper"

RSpec.describe "Donation form modal", type: :system do
  let(:campaign) { create(:campaign, goal_amount: 10_000) }
  let!(:tree_option) { create(:donation_option, campaign: campaign, amount: 180, label: "נטיעת עץ") }
  let!(:featured_option) { create(:donation_option, campaign: campaign, amount: 360, label: "נטיעת 2 עצים", featured: true) }

  before { visit campaign_path(campaign.slug) }

  def open_modal
    click_button "לתרומה"
    expect(page).to have_css("dialog[open]")
  end

  it "opens the modal with the donation form and flags the featured amount" do
    open_modal

    within "dialog" do
      expect(page).to have_content("בחרו סכום לתרומה")
      expect(page).to have_field("180 ₪ נטיעת עץ", type: "radio")

      featured_tile = find("label", text: "נטיעת 2 עצים")
      expect(featured_tile).to have_content("🧡 הכי נבחר")
    end
  end

  it "creates a pending donation, closes the modal, and updates the raised amount on success" do
    open_modal

    within "dialog" do
      choose "180 ₪ נטיעת עץ"
      fill_in "שם מלא", with: "דנה כהן"
      fill_in "אימייל", with: "dana@example.com"
      click_button "המשך לתרומה"
    end

    expect(page).to have_no_css("dialog[open]")
    expect(page).to have_content("תודה! התרומה שלך התקבלה והיא ממתינה לאישור")
    expect(page).to have_content("180.00 ₪ גויסו")

    donation = campaign.donations.find_by!(donor_email: "dana@example.com")
    expect(donation).to be_pending
    expect(donation.amount).to eq(180)
  end

  it "shows inline validation errors and keeps the modal open when the amount is missing" do
    open_modal

    within "dialog" do
      fill_in "שם מלא", with: "ללא סכום"
      fill_in "אימייל", with: "noamount@example.com"
      click_button "המשך לתרומה"

      expect(page).to have_content("לא ניתן היה לשמור את התרומה")
      expect(page).to have_content("סכום לא יכול להישאר ריק")
    end

    expect(page).to have_css("dialog[open]")
    expect(campaign.donations.exists?(donor_email: "noamount@example.com")).to be false
  end
end
