# frozen_string_literal: true

class RelationshipsController < ApplicationController
  before_action :authenticate_user!, only: [:follow, :unfollow]
  def follow
    @user = User.find(params[:id]) # 非同期はこれがないとダメ
    current_user.follow(params[:id])
    @user.create_notification_follow!(current_user)
  end

  def unfollow
    @user = User.find(params[:id]) # 非同期はこれがないとダメ
    current_user.unfollow(params[:id])
  end
end
