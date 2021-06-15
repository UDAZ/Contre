# frozen_string_literal: true

class RelationshipsController < ApplicationController
  def follow
    @user = User.find(params[:id]) # 非同期はこれがないとダメ
    current_user.follow(params[:id])
  end

  def unfollow
    @user = User.find(params[:id]) # 非同期はこれがないとダメ
    current_user.unfollow(params[:id])
  end
end
