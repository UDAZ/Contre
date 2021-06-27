# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :ensure_correct_user, only: [:update, :edit]
  def index
    # .orderでソートできる。
    @users = User.order('contributions DESC').page(params[:page]).per(10)
    # ランキングとページネート用、これがないと次ページでランキングが一位になってしまう。
    @page = 1
    # 2ページ目は11位から3ページ目は21位から始まるようになる。
    @page = (params[:page].to_i - 1) * 10 + 1 if params[:page]
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.includes([:genre]).page(params[:page]).per(10)
  end

  def edit
    @user = User.find(params[:id])
    github_name = "\"#{@user.name}\""
    uri = URI.parse('https://api.github.com/graphql')
    request = Net::HTTP::Post.new(uri)
    # github apiにtokenで接続
    request['Authorization'] = ENV['GITHUB_API']
    # totalContributionsの取得を要請
    request.body = JSON.dump({ 'query' => "query {user (login: #{github_name}) {contributionsCollection {contributionCalendar {totalContributions}}}}" })
    req_options = {
      use_ssl: uri.scheme == 'https'
    }
    # requesetに対するresponseを取得
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    # responseのbody(json型)から数字のみ取り出す
    @contributions = if response.body.include?('error')
                       0
                     else
                       response.body.gsub(/[^\d]/, '').to_i
                     end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: t('user.updated')
    else
      redirect_to edit_user_path(@user.id)
    end
  end

  def follows
    @user = User.find(params[:user_id])
  end

  def followers
    @user = User.find(params[:user_id])
  end

  private

  def user_params
    params.require(:user).permit(:contributions)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
