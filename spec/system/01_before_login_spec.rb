
require 'rails_helper'

describe '[ログイン前]' do
  describe '[ヘッダー]' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'Aboutリンクがある。' do
        expect(find_link('About'))
      end
      it 'GitHubでログインリンクがある。' do
        expect(find_link('GitHubでログイン'))
      end
    end
    context 'リンクの確認' do
      it 'About画面へのリンクは/aboutになっている。' do
        about_link = find_link('About')[:href]
        expect(about_link).to match('/about')
      end
      it 'GitHubでログインのリンクは/users/auth/githubになっている。' do
        about_link = find_link('GitHubでログイン')[:href]
        expect(about_link).to match('/users/auth/github')
      end
    end
  end
  describe '[フッター]' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it '©UDAZの記載がある。' do
        expect(page).to have_text '©UDAZ'
      end
      it '日本語がデフォルト言語なのでEnglishに変更するリンクがある。' do
        expect(find_link('English'))
      end
    end
    context 'リンクの確認' do
      it 'Englishに変更するリンクは/change_language/enになっている。' do
        english_link = find_link('English')[:href]
        expect(english_link).to match('/change_language/en')
      end
    end
  end
  describe '[トップ画面]' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'トップ画面のURLは/である' do
        expect(current_path).to eq '/'
      end
    end
    context '日本語版の確認' do
      before do
        visit '/change_language/ja'
      end
      it '日本語版だと、どうする？の記載がある。' do
        expect(page).to have_text 'どうする？'
      end
    end
    context '英語版の確認' do
      before do
        visit '/change_language/en'
      end
      it '英語版だと、What will you do?の記載がある。' do
        expect(page).to have_text 'What will you do?'
      end
    end
    context '動作の確認' do
      before do
        visit '/change_language/ja'
      end
      it 'input id=”name”に「UDAZ」と入力してSubmitをクリックすると0以外の数字が記載されたトップに移動する。' do
        fill_in 'name', with: 'UDAZ'
        click_button 'こんとる'
        contre_field = find_all('h1')[2].native.inner_text
        expect(contre_field).to match(/\+?[1-9][0-9]/i)
      end
      it 'input id=”name”に「あああ」と入力してSubmitをクリックするとErrorが記載されたトップに移動する。' do
        fill_in 'name', with: 'あああ'
        click_button 'こんとる'
        expect(page).to have_text 'Error'
      end
    end
  end
  describe '[アバウト]' do
    before do
      visit about_path
    end

    context '表示内容の確認' do
      it 'アバウト画面のURLは/aboutである' do
        expect(current_path).to eq '/about'
      end
      it 'Check on GitHubリンクがある' do
        expect(find_link('Check on GitHub'))
      end
    end
    context 'リンクの確認' do
      it 'Check on GitHubリンクのURLはhttps://github.com/UDAZ/Contreである' do
        cog_link = find_link('Check on GitHub')[:href]
        expect(cog_link).to match('https://github.com/UDAZ/Contre')
      end
    end
    context '日本語版の確認' do
      before do
        visit '/change_language/ja'
        visit about_path
      end
      it '日本語版だと、About こんとるの記載がある。' do
        expect(page).to have_text 'About こんとる'
      end
    end
    context '英語版の確認' do
      before do
        visit '/change_language/en'
        visit about_path
      end
      it '英語版だと、About Contreの記載がある。' do
        expect(page).to have_text 'About Contre'
      end
    end
  end
  describe '[投稿一覧]' do
    before do
      visit posts_path
    end

    context '表示内容の確認' do
      it '投稿一覧画面のURLは/postsである' do
        expect(current_path).to eq '/posts'
      end
    end
    context '日本語版の確認' do
      before do
        visit '/change_language/ja'
        visit posts_path
      end
      it '日本語版だと、ジャンルの記載がある。' do
        expect(page).to have_text 'ジャンル'
      end
    end
    context '英語版の確認' do
      before do
        visit '/change_language/en'
        visit posts_path
      end
      it '英語版だと、Genreの記載がある。' do
        expect(page).to have_text 'Genre'
      end
    end
  end
end