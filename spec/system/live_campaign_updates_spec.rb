require "rails_helper"

RSpec.describe "Live campaign updates via Turbo Streams", type: :system do
  let(:campaign) { create(:campaign, goal_amount: 10_000) }
  let!(:option) { create(:donation_option, campaign: campaign, amount: 250, label: "תרומה רגילה") }

  it "broadcasts the new totals and donation to other viewers without a reload" do
    using_session("viewer") do
      visit campaign_path(campaign.slug)
      click_button "תרומות אחרונות"
      expect(page).to have_content("עדיין אין תרומות להצגה")
    end

    using_session("donor") do
      visit campaign_path(campaign.slug)
      click_button "לתרומה"

      within "dialog" do
        choose "250 ₪ תרומה רגילה"
        fill_in "שם מלא", with: "רותם לוי"
        fill_in "אימייל", with: "rotem@example.com"
        choose "השם הפרטי שלי בלבד"
        click_button "המשך לתרומה"
      end

      expect(page).to have_content("תודה!")
    end

    using_session("viewer") do
      expect(page).to have_content("250.00 ₪ גויסו")
      expect(page).to have_content("רותם ל.")
      expect(page).to have_no_content("עדיין אין תרומות להצגה")
    end
  end
end
