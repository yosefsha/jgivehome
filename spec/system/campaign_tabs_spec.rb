require "rails_helper"

RSpec.describe "Campaign tabs", type: :system do
  let(:campaign) { create(:campaign, story: "הסיפור המלא של הקמפיין נמצא כאן.") }

  before { visit campaign_path(campaign.slug) }

  it "shows the project story under 'About the project' by default" do
    expect(page).to have_css("[data-tabs-target='panel'][data-tabs-name-param='about_project']", text: campaign.story, visible: :visible)
    expect(page).to have_css("[data-tabs-target='panel'][data-tabs-name-param='recent_donations']", visible: :hidden)
  end

  it "reveals each tab's panel when clicked and hides the others" do
    {
      "תרומות אחרונות" => "recent_donations",
      "לוח שגרירים" => "ambassador_board",
      "קבוצות" => "groups",
      "על העמותה" => "about_charity",
      "עדכונים" => "updates",
      "על הפרויקט" => "about_project"
    }.each do |label, name|
      click_button label

      expect(page).to have_css("[data-tabs-target='panel'][data-tabs-name-param='#{name}']", visible: :visible)

      other_panels = page.all("[data-tabs-target='panel']", visible: :all).reject do |panel|
        panel["data-tabs-name-param"] == name
      end
      other_panels.each { |panel| expect(panel).not_to be_visible }
    end
  end
end
