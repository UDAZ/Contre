class Post < ApplicationRecord
  belongs_to :genre
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :notifications, dependent: :destroy
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
  def reported_by?(user)
    reports.where(user_id: user.id).exists?
  end
end
