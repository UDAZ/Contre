class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
    @genres = Genre.all
  end
  
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.save
  end

  def edit
    @post = Post.find(params[:id])
  end
  
  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
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
