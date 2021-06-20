# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
11.times do |n|
  User.create!(
    name: "test#{n + 1}",
    uid: "11111#{n + 1}",
    provider: "github",
    contributions: "20#{n + 1}",
    email: "test#{n + 1}@test.com",
    password: "111111",
    github_url: "https://github.com/test#{n + 1}"
  )
end
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
])