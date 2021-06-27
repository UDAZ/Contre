
require 'rails_helper'

describe '[ログイン前]' do
  before do
    #テスト用データを読み込む
    @user = FactoryBot.create(:user, :a)
    @second_user = FactoryBot.create(:user, :b)
    @third_user = FactoryBot.create(:user, :c)
    @post = FactoryBot.create(:post, :a, user_id: @user.id)
    @second_post = FactoryBot.create(:post, :b, user_id: @second_user.id)
    @relation = FactoryBot.create(:relationship, follower_id: @user.id, followed_id: @second_user.id)
  end
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
        click_button 'こんとる', wait: 5
        contre_field = find('h1#contributions').text
        expect(contre_field).to match(/\+?[1-9][0-9]/i)
      end
      it 'input id=”name”に「あああ」と入力してSubmitをクリックするとErrorが記載されたトップに移動する。' do
        fill_in 'name', with: 'あああ'
        click_button 'こんとる', wait: 5
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
      it '長すぎるタイトルは13文字と...になっている' do
        expect(page).to have_text(/…/i)
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
    context '動作の確認' do
      it 'Goodボタン、favoritesは動作しない' do
        buttonarea = find_by_id('favs_buttons_1')
        button = buttonarea.find('a.fav')
        button.click
        expect(button).not_to have_text '1'        
      end
      it 'Goodボタンを押しても何も起きない、登録を促すmodalがでる' do
        buttonarea = find_by_id('favs_buttons_1')
        button = buttonarea.find('a.fav')
        button.click
        expect(find('.modal')).to be_visible 
      end
    end
  end
  describe '[投稿詳細]' do
    before do
      visit post_path(@post)
    end

    context '表示内容の確認' do
      it '投稿詳細画面のURLは/posts/1である。' do
        expect(current_path).to eq "/posts/#{@post.id}"
      end
      it '長すぎるタイトルは13文字と...になっている' do
        expect(page).to have_text(/…/i)
      end
      it '本文はマークダウン記法になっている' do
        expect(find('.markdown'))
      end
      it '投稿したユーザーの情報が表示されている' do
        visit '/change_language/en'
        visit post_path(@post)
        expect(page).to have_text 'Name'
      end
    end
    context '日本語版の確認' do
      before do
        visit '/change_language/ja'
        visit post_path(@post)
      end
      it '日本語版だと、投稿の記載がある。' do
        expect(page).to have_text '投稿'
      end
    end
    context '英語版の確認' do
      before do
        visit '/change_language/en'
        visit post_path(@post)
      end
      it '英語版だと、Postの記載がある。' do
        expect(page).to have_text 'Post'
      end
    end
    context '動作の確認' do
      it 'Goodボタン、favoritesは動作しない' do
        button = find_by_id('favs_buttons_1')
        button.click
        expect(button).to have_text '0'        
      end
      it 'Goodボタンを押しても何も起きない、登録を促すmodalがでる' do
        button = find('a.fav')
        button.click
        expect(find('.modal')).to be_visible 
      end
    end
  end
  describe '[コントリビューションランキング]' do
    before do
      visit users_path
    end

    context '表示内容の確認' do
      it 'コントリビューションランキングのURLは/rankingである。' do
        expect(current_path).to eq '/ranking'
      end
    end
    context '日本語版の確認' do
      before do
        visit '/change_language/ja'
        visit users_path
      end
      it '日本語版だと、投稿の記載がある。' do
        expect(page).to have_text 'ランク'
      end
    end
    context '英語版の確認' do
      before do
        visit '/change_language/en'
        visit users_path
      end
      it '英語版だと、Postの記載がある。' do
        expect(page).to have_text 'Rank'
      end
    end
    context '動作の確認' do
      it 'test11のShowボタンを押すとtest11のユーザーページに遷移する' do
        find_by_id('u-link-16').click
        expect(current_path).to eq "/users/16"
      end
      it '次ページに移動するとランクは11位からになっている' do
        visit '/ranking?page=2'
        expect(page).to have_text('11')
      end
    end
  end
  describe '[ユーザーページ]' do
    before do
      visit user_path(1)
    end

    context '表示内容の確認' do
      before do
        visit '/change_language/ja'
        visit user_path(@user)
      end
      it 'test1のURLは/users/1である。' do
        expect(current_path).to eq "/users/#{@user.id}"
      end
      it '.svgの画像ファイルが表示されている' do
        expect(page).to have_selector("img")
      end
      it 'ユーザーの投稿一覧がある' do
        expect(page).to have_text("Taroの投稿")
      end
      it 'ユーザーの投稿がない場合、投稿はありませんと表示される' do
        visit user_path(@third_user)
        expect(page).to have_text("投稿はありません")
      end
      it 'Check on GitHubリンクのURLはhttps://github.com/test1である' do
        cog_link = find_link('GitHubへ行く')[:href]
        expect(cog_link).to match("https://github.com/#{@user.name}")
      end
      it '長すぎるタイトルは13文字と...になっている' do
        visit user_path(@second_user)
        expect(page).to have_text("…")
      end
    end
    context '日本語版の確認' do
      before do
        visit '/change_language/ja'
        visit user_path(1)
      end
      it '日本語版だと、コントリビューションの記載がある。' do
        expect(page).to have_text 'コントリビューション'
      end
    end
    context '英語版の確認' do
      before do
        visit '/change_language/en'
        visit user_path(1)
      end
      it '英語版だと、Postの記載がある。' do
        expect(page).to have_text 'Contributions'
      end
    end
  end
  describe '[フォローページ]' do
    before do
      visit user_follows_path(@user)
    end

    context '表示内容の確認' do
      it '@userのURLは/users/@user.id/followsである。' do
        expect(current_path).to eq "/users/#{@user.id}/follows"
      end
      it 'フォローしているユーザーいない場合、このユーザーのフォローは0です。とでる' do
        visit user_follows_path(3)
        expect(page).to have_text 'このユーザーのフォローは0です。'
      end
    end
    context '日本語版の確認' do
      before do
        visit '/change_language/ja'
        visit user_follows_path(@user)
      end
      it '日本語版だと、ユーザー名の記載がある。' do
        expect(page).to have_text 'ユーザー名'
      end
    end
    context '英語版だと、Nameの記載がある。' do
      before do
        visit '/change_language/en'
        visit user_follows_path(@user)
      end
      it '英語版だと、Postの記載がある。' do
        expect(page).to have_text 'Name'
      end
    end
    context '動作の確認' do
      before do
        visit user_follows_path(@user)
      end
      it 'リストにユーザーがいる場合、フォロー数のカウントが表示されている。' do
        expect(find('a.followcount'))
      end
      it 'リストにユーザーがいる場合、フォロワー数のカウントが表示されている。' do
        expect(find('a.followercount'))
      end
      it 'リストにいるユーザーのフォローカウントをクリックするとユーザーのフォローページに遷移する' do
        find('a.followcount').click
        expect(current_path).to eq "/users/#{@second_user.id}/follows"
      end
      it 'リストにいるユーザーのフォロワーカウントをクリックするとユーザーのフォロワーページに遷移する' do
        find('a.followercount').click
        expect(current_path).to eq "/users/#{@second_user.id}/followers"
      end
    end
  end
  describe '[フォロワーページ]' do
    before do
      visit user_followers_path(@second_user)
    end

    context '表示内容の確認' do
      it '@second_userのURLは/users/@second_use.id/followersである。' do
        expect(current_path).to eq "/users/#{@second_user.id}/followers"
      end
      it 'フォロワーになっているユーザーいない場合、このユーザーのフォロワーは0です。とでる' do
        visit user_followers_path(3)
        expect(page).to have_text 'このユーザーのフォロワーは0です。'
      end
    end
    context '日本語版の確認' do
      before do
        visit '/change_language/ja'
        visit user_followers_path(@second_user)
      end
      it '日本語版だと、ユーザー名の記載がある。' do
        expect(page).to have_text 'ユーザー名'
      end
    end
    context '英語版だと、Nameの記載がある。' do
      before do
        visit '/change_language/en'
        visit user_followers_path(@second_user)
      end
      it '英語版だと、Postの記載がある。' do
        expect(page).to have_text 'Name'
      end
    end
    context '動作の確認' do
      before do
        visit user_followers_path(@second_user)
      end
      it 'リストにユーザーがいる場合、フォロー数のカウントが表示されている。' do
        expect(find('a.followcount'))
      end
      it 'リストにユーザーがいる場合、フォロワー数のカウントが表示されている。' do
        expect(find('a.followercount'))
      end
      it 'リストにいるユーザーのフォローカウントをクリックするとユーザーのフォローページに遷移する' do
        find('a.followcount').click
        expect(current_path).to eq "/users/#{@user.id}/follows"
      end
      it 'リストにいるユーザーのフォロワーカウントをクリックするとユーザーのフォロワーページに遷移する' do
        find('a.followercount').click
        expect(current_path).to eq "/users/#{@user.id}/followers"
      end
    end
  end
end