FactoryBot.define do
  factory :campaign do
    sequence(:title) { |n| "Campaign #{n}" }
    story { "A story about why this campaign matters." }
    cover_image_url { "https://example.com/cover.jpg" }
    goal_amount { 5_000_000 }
    sequence(:slug) { |n| "campaign-#{n}" }
  end
end
