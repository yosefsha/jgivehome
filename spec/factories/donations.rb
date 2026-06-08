FactoryBot.define do
  factory :donation do
    campaign
    amount { 100 }
    frequency { :one_time }
    status { :pending }
    donor_name { "Yosef Shachnovsky" }
    sequence(:donor_email) { |n| "donor#{n}@example.com" }
    display_preference { :full_name }
    dedication_message { nil }
  end
end
