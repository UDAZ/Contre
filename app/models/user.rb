class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :uid, presence: true, uniqueness: { scope: :provider }
  has_many :follower, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy # フォロー取得
  has_many :followed, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy # フォロワー取得
  has_many :following_user, through: :follower, source: :followed # 自分がフォローしている人
  has_many :follower_user, through: :followed, source: :follower # 自分をフォローしている人
  has_many :posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visiter_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
  def create_notification_follow!(current_user)
    temp = Notification.where(['visiter_id = ? and visited_id = ? and action = ? ', current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  # ユーザーをフォローする
  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  # ユーザーのフォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  # フォローしていればtrueを返す
  def following?(user)
    following_user.include?(user)
  end

  def self.find_for_github_oauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.github_url = 'https://github.com/' + auth.info.name
      # githubのnameを取得
      github_name = '"' + auth.info.name + '"'
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
      user.contributions = response.body.gsub(/[^\d]/, '').to_i
    end
  end
end
