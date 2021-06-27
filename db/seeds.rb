# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'
15.times do |n|
  Faker::Config.locale = 'en'
  name = Faker::Name.first_name
  email = Faker::Internet.email
  User.create!(
    name: name,
    uid: "11111#{n + 1}",
    provider: "github",
    contributions: "20#{n + 1}",
    email: email,
    password: "111111",
    github_url: "https://github.com/#{name}"
  )
end
User.create(
  name: "Guest",
  uid: "11111",
  provider: "github",
  contributions: "4670",
  email: "test@com",
  password: "111111",
  github_url: "https://github.com/Guest"
)
Genre.create([
    {name: "AWS"},
    {name: "HTML"},
    {name: "CSS"},
    {name: "Ruby"},
    {name: "Rails"},
    {name: "Javascript"},
    {name: "ポートフォリオ"},
    {name: "その他"}
])
Notification.create([
    {visiter_id: "11", visited_id: "12", action: "follow", created_at: "2021-06-19 13:19:56.788658", updated_at: "2021-06-19 13:19:56.788658"},
    {visiter_id: "10", visited_id: "12", action: "follow", created_at: "2021-06-19 13:19:56.788658", updated_at: "2021-06-19 13:19:56.788658"},
    {visiter_id: "2", visited_id: "5", action: "follow", created_at: "2021-06-19 13:19:56.788658", updated_at: "2021-06-19 13:19:56.788658"},
])
Relationship.create([
  {follower_id: "11", followed_id: "12"},
  {follower_id: "10", followed_id: "12"},
  {follower_id: "2", followed_id: "5"}
])