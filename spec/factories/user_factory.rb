FactoryBot.define do
  factory :user do
    role { :supplier }

    trait :admin do
      role { :admin }
    end
  end
end
