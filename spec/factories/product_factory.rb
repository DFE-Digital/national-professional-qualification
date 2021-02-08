FactoryBot.define do
  factory :product do
    supplier
    name { "My Product" }
    start_at { Date.today + 1.month }
  end
end
