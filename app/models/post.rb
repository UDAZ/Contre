class Post < ApplicationRecord
  belongs_to :genre
  belongs_to :user
  validates :title, presence: true
  validates :body, presence: true
  validates :genre, presence: true
  has_many :favorites, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :notifications, dependent: :destroy
  def create_notification_by(current_user)
    temp = Notification.where(['visiter_id = ? and visited_id = ? and post_id = ? and action = ? ', current_user.id,
                               user_id, id, 'fav'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        post_id: id,
        visited_id: user_id,
        action: 'fav'
      )
      notification.save if notification.valid?
    end
  end

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def reported_by?(user)
    reports.where(user_id: user.id).exists?
  end
end
