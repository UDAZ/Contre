class ReportsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    report = current_user.reports.build(post_id: params[:post_id], description: params[:description])
    report.save
    redirect_to post_path(@post)
  end
end
