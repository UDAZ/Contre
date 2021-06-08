class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :uid, presence: true, uniqueness: { scope: :provider }
  def self.find_for_github_oauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create! do |user| 
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.github_url = "https://github.com/" + auth.info.name
      #githubのnameを取得
      github_name = '"' + auth.info.name + '"'
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
      user.contributions = response.body.gsub(/[^\d]/, "").to_i
    end
  end
end
