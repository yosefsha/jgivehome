FactoryBot.define do
  factory :donation_option do
    campaign
    amount { 180 }
    label { "נטיעת עץ" }
    featured { false }
  end
end
