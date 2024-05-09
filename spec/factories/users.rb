FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "securepassword" }
    role { "estudiante" } # El rol predeterminado

    trait :admin do
      role { "admin" }
    end

    trait :coder do
      role { "coder" }
    end

    trait :estudiante do
      role { "estudiante" }
    end
  end
end
