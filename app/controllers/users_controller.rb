class UsersController < ApplicationController
  def index
  end

  def show
    @user = User.find(params[:id])
  end
  
  def edit
    @user = User.find(params[:id])
    github_name = '"' + @user.name + '"'
    uri = URI.parse("https://api.github.com/graphql")
    request = Net::HTTP::Post.new(uri)
    #github apiにtokenで接続
    request["Authorization"] = ENV['GITHUB_API']
    #totalContributionsの取得を要請
    request.body = JSON.dump({"query" => "query {user (login: #{github_name}) {contributionsCollection {contributionCalendar {totalContributions}}}}"})
    req_options = {
      use_ssl: uri.scheme == "https"
    }
    #requesetに対するresponseを取得
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    #responseのbody(json型)から数字のみ取り出す
    @contributions = response.body.gsub(/[^\d]/, "").to_i
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "You have updated contributions successfully."
    else
      redirect_to edit_user_path(@user.id)
    end
  end
  
  def follows
  end
  
  def followers
  end

  private

  def user_params
    params.require(:user).permit(:contributions)
  end
end
