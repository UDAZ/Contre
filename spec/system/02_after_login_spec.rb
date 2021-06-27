
require 'rails_helper'

describe '[ログイン後]' do
  before do
    #テスト用データを読み込む
    @user = FactoryBot.create(:user, :a)
    @second_user = FactoryBot.create(:user, :b)
    @third_user = FactoryBot.create(:user, :c)
    @post = FactoryBot.create(:post, :a, user_id: @user.id)
    @second_post = FactoryBot.create(:post, :b, user_id: @user.id)
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
        button_area = find_by_id('favs_buttons_2')
        button = button_area.find('a.fav')
        button.click
        expect(button).to have_text '1'    
      end
    end
  end
  describe '[投稿詳細]' do
    before do
      sign_in @user
      visit post_path(2)
    end

    context '動作の確認' do
      it '非同期で投稿にいいねすることができる' do
        button_area = find_by_id('favs_buttons_2')
        button = button_area.find('a.fav')
        button.click
        expect(button).to have_text '1'    
      end
      it '非同期で投稿にいいね解除することができる' do
        button_area = find_by_id('favs_buttons_2')
        button = button_area.find('a.fav')
        button.click wait: 5
        button.click
        expect(button).to have_text '0'    
      end
      it '投稿を運営に通報できる' do
        button = find_by_id('repo')
        button.click wait: 3
        expect(find('.modal')).to be_visible  
      end
      it '通報後、通報した投稿詳細に遷移して、通報済みですと表示される。' do
        button = find_by_id('repo')
        button.click wait: 3
        fill_in 'description', with: 'UDAZ'
        click_button '送信', wait: 5
        expect(page).to have_text '通報済みです'    
      end
    end
    context '自分の投稿の動作の確認' do
      before do
      visit post_path(@post)
      end
      it '自分の投稿の場合、投稿内容を編集するリンクが出てきて、posts/:id/editに飛ぶ' do
        button = find_link('編集')
        button.click wait: 3
        expect(current_path).to eq "/posts/#{@post.id}/edit" 
      end
      it '自分の投稿の場合、投稿内容を削除するリンクが出てきて、マイページに飛ぶ' do
        button = find_link('削除')
        button.click wait: 3
        page.accept_confirm wait: 3
        expect(current_path).to eq "/users/#{@user.id}" 
      end
    end
  end
  describe '[ユーザーページ]' do
    before do
      sign_in @user
    end

    context 'マイページの動作の確認' do
      before do
        visit user_path(@user)
      end
      it 'マイページの場合コントリビューション更新リンクがある。' do
        expect(find_link('コントリビューション更新'))  
      end
      it 'マイページの場合新規投稿のリンクがある。' do
        expect(find_link('新規投稿'))  
      end
    end
    context 'マイページ以外の動作の確認' do
      before do
        visit user_path(3)
      end
      it 'ユーザーが自身ではない場合非同期でユーザーをフォローすることができる' do
        button = find_link('フォロー')
        button.click wait: 3
        expect(find_link('フォロー解除'))
      end
      it 'ユーザーが自身ではない場合非同期でユーザーをフォロー解除することができる' do
        button = find_link('フォロー')
        button.click wait: 3
        button.click wait: 3
        expect(find_link('フォロー'))
      end
    end
  end
  describe '[コントリビューション更新]' do
    before do
      sign_in @user
      visit edit_user_path(@user)
    end
    context '表示の確認' do
      it '遷移してくると最新のコントリビューション数が表示される。' do
        field = find('#user_contributions')
        expect(field.value).to match(/[0-9]/i)
      end
      it '最新のコントリビューション数はreadonly属性である。' do
        field = find('#user_contributions')
        expect(field).to be_readonly
      end
    end
    context '動作の確認' do
      it '更新ボタンを押すとマイページに遷移する。' do
        field_value = find('#user_contributions').value
        click_button('更新', wait: 5)
        expect(current_path).to eq user_path(@user)
      end
    end
  end
  describe '[新規投稿]' do
    before do
      sign_in @user
      visit new_post_path
    end

    context '動作の確認' do
      it 'タイトルとジャンルと本文を入力して、送信を押すと新規投稿ができる。新規投稿ができたら、作成された投稿のページに遷移する' do
        fill_in 'post[title]', with: 'UDAZ'
        fill_in 'post[body]', with: 'UDAZ'
        select "AWS", from: "post_genre_id"
        click_button '送信', wait: 5
        expect(current_path).to eq "/posts/4"
      end
      it 'タイトルとジャンルと本文のいずれかがない場合投稿ができない' do
        fill_in 'post[title]', with: 'UDAZ'
        fill_in 'post[body]', with: 'UDAZ'
        click_button '送信', wait: 5
        expect(page).to have_text('ジャンルを入力してください')
      end
      it 'マークダウン記法で投稿ができる' do
        fill_in 'post[body]', with: '#UDAZ', wait: 5
        field_value = find('#post_body', wait: 5).value
        expect(field_value).not_to eq "UDAZ"
      end
      it '画面サイズがｌｇ以上の場合プレビューが出てくる' do
        expect(page).to have_text('プレビュー')
      end
    end
  end
  describe '[投稿編集]' do
    before do
      sign_in @user
      visit edit_post_path(@post)
    end

    context '動作の確認' do
      it 'タイトルとジャンルと本文を入力して、送信を押すと投稿編集ができる。投稿編集ができたら、作成された投稿のページに遷移する' do
        fill_in 'post[title]', with: 'UDAZ'
        fill_in 'post[body]', with: 'UDAZ'
        select "AWS", from: "post_genre_id"
        click_button '送信', wait: 5
        expect(current_path).to eq "/posts/3"
      end
      it 'タイトルとジャンルと本文のいずれかがない場合投稿ができない' do
        fill_in 'post[title]', with: 'UDAZ'
        fill_in 'post[body]', with: ''
        click_button '送信', wait: 5
        expect(page).to have_text('本文を入力してください')
      end
      it 'マークダウン記法で投稿ができる' do
        fill_in 'post[body]', with: '#UDAZ', wait: 5
        field_value = find('#post_body', wait: 5).value
        expect(field_value).not_to eq "UDAZ"
      end
      it '画面サイズがｌｇ以上の場合プレビューが出てくる' do
        expect(page).to have_text('プレビュー')
      end
    end
  end
  describe '[フォローページ]' do
    context '自分のフォローの確認' do
      before do
        sign_in @user
        visit user_path(1)
        find_link('フォロー').click
        visit user_follows_path(@user)
      end
      it 'ユーザーがフォローしているユーザーが表示され、自身がフォローしている場合はフォロー解除、自身がフォローしていない場合はフォロー解除が表示される。' do
        find_link('フォロー解除').click wait: 3
        expect(find_link('フォロー'))  
      end
    end
    context '他人のフォローの確認' do
      before do
        sign_in @second_user
        visit user_path(@user)
        find_link('フォロー').click
      end
      it '自身がリストにいる場合はどちらも表示されない' do
        sign_in @user
        visit user_follows_path(@second_user)
        expect(page).not_to match('btn-outline-dark')
      end
    end
  end
  describe '[フォロワーページ]' do
    context '自分のフォロワーの確認' do
      before do
        sign_in @second_user
        visit user_path(@user)
        find_link('フォロー').click
        sign_in @user
        visit user_followers_path(@user)
      end
      it 'ユーザーがフォローしているユーザーが表示され、自身がフォローしている場合はフォロー解除、自身がフォローしていない場合はフォロー解除が表示される。' do
        find_link('フォロー').click wait: 3
        expect(find_link('フォロー解除'))  
      end
    end
    context '他人のフォローの確認' do
      before do
        sign_in @user
        visit user_path(@second_user)
        find_link('フォロー').click
        visit user_followers_path(@second_user)
      end
      it '自身がリストにいる場合はどちらも表示されない' do
        expect(page).not_to match('btn-outline-dark')
      end
    end
  end
end