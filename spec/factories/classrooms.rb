FactoryBot.define do
  factory :classroom do
    teacher { nil }
    assistant { nil }
    day_count { 1 }
    hours_per_class { 1 }
    price_per_student { "9.99" }
    status { "MyString" }
  end
end
