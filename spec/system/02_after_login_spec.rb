
require 'rails_helper'

describe '[ログイン後]' do
  before do
    #テスト用データを読み込む
    @user = FactoryBot.create(:user)
  end
  describe '[ヘッダー]' do
    before do
      sign_in @user
      visit root_path
    end

    context '表示内容の確認' do
      it 'マイページリンクがある。' do
        expect(find_link('マイページ'))
      end
      it 'マイページへのリンクは自信のユーザーIDになっている。' do
        mypage_link = find_link('マイページ')[:href]
        my_link = '/users/' + @user.id.to_s
        expect(mypage_link).to match(my_link)
      end
      it '通知のリンクがある' do
        expect(find_link('通知'))
      end
      it 'ログアウトリンクがある' do
        expect(find_link('ログアウト'))
      end
      it 'ログアウトすると、ログイン前のトップページに戻る' do
        find_link('ログアウト').click
        about_link = find_link('About')
        expect(about_link)
      end
    end
  end
  describe '[投稿一覧]' do
    before do
      sign_in @user
      visit posts_path
    end

    context '動作の確認' do
      it '非同期で投稿にいいねすることができる' do
        post_link = find_all('a')[8]
        post_link.click
        expect(post_link).to match('1')
      end
    end
  end
end