FactoryBot.define do
  factory :post do
    trait :a do
      title             { 'テスト投稿' }
      genre_id                 { '1' }
      body { 'ggggggg' }
    end
    trait :b do
      title             { 'テスト投稿テスト投稿テスト投稿テスト投稿テスト投稿テスト投稿テスト投稿テスト投稿' }
      genre_id                 { '1' }
      body { 'ggggggg' }
    end
  end
end
