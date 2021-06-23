
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
      it 'About画面へのリンクは/aboutになっている。' do
        about_link = find_link('About')[:href]
        expect(about_link).to match('/about')
      end
      it 'GitHubでログインリンクがある。' do
        expect(find_link('GitHubでログイン'))
      end
      it 'GitHubでログインのリンクは/users/auth/githubになっている。' do
        about_link = find_link('GitHubでログイン')[:href]
        expect(about_link).to match('/users/auth/github')
      end
    end
  end
  describe '[トップ画面]' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
    end
  end
end