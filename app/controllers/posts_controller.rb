class PostsController < ApplicationController
  def index
    @posts = Post.all.page(params[:page]).per(10)
  end

  def new
    @post = Post.new
    @genres = Genre.all
  end
  
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.save
    redirect_to post_path(@post)
  end

  def edit
    @post = Post.find(params[:id])
    @genres = Genre.all
  end
  
  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    redirect_to post_path(@post)
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to user_path(@post.user)
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
