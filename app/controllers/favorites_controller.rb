class FavoritesController < ApplicationController

    def create
        @post = Post.find(params[:post_id])
        favorite = current_user.favorites.build(post_id: params[:post_id])
        favorite.save
        redirect_to request.referer
    end
    
    def destroy
        @post = Post.find(params[:post_id])
        favorite = current_user.favorites.find_by(post_id: params[:post_id], user_id: current_user.id)
        favorite.destroy
        redirect_to request.referer
    end

end
