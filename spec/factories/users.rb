FactoryBot.define do
  factory :user do
    trait :a do
      name                  { 'Taro' }
      email                 { Faker::Internet.free_email }
      password              { 'aaBB1234' }
      contributions         {'3200'}
      password_confirmation { password }
      uid                   { '11223334' }
      provider              { 'github' }
    end
    trait :b do
      name                  { 'Jiro' }
      email                 { Faker::Internet.free_email }
      password              { 'aaBB1234' }
      contributions         {'3200'}
      password_confirmation { password }
      uid                   { '112233344' }
      provider              { 'github' }
    end
    trait :c do
      name                  { 'Ken' }
      email                 { Faker::Internet.free_email }
      password              { 'aaBB1234' }
      contributions         {'3200'}
      password_confirmation { password }
      uid                   { '1122333444' }
      provider              { 'github' }
    end
  end
end
