FactoryBot.define do
  factory :user do
    name              { 'Taro' }
    email                 { Faker::Internet.free_email }
    password              { 'aaBB1234' }
    password_confirmation { password }
    uid           { '11223334' }
    provider            { 'github' }
  end
end