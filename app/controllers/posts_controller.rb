# frozen_string_literal: true

class PostsController < ApplicationController
  def index
    @posts = Post.all.includes([:genre], [:user]).page(params[:page]).per(10)
  end

  def new
    @post = Post.new
    @genres = Genre.all
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @genres = Genre.all
    if @post.save
      redirect_to post_path(@post), notice: "#{t'posts.newsuccess'}"
    else
      flash.now[:alert] = @post.errors.full_messages
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    @genres = Genre.all
  end

  def update
    @post = Post.find(params[:id])
    @genres = Genre.all
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "#{t'posts.editsuccess'}"
    else
      flash.now[:alert] = @post.errors.full_messages
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to user_path(@post.user), notice: "#{t'posts.deletesuccess'}"
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
  end

  private

  def post_params
    params.require(:post).permit(:title, :genre_id, :body)
  end
end
