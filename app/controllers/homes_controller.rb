class HomesController < ApplicationController
  def top
    if params[:name].present?
      github_name = '"' + params[:name] + '"'
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
      #responseのbody(json型)から数字のみ取り出す、エラーが起きた場合はErrorを返す。
      if response.body.include?("error")
        @contributions = "Error"
      else
        @contributions = response.body.gsub(/[^\d]/, "").to_i
      end
    end
  end

  def about
  end
  def change_language
    session[:locale] = params[:language]
    redirect_back(fallback_location: "/")
  end
end
