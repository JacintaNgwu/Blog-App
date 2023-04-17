class PostsController < ApplicationController
  def index; end

  def show
    @user = User.find(params[:user_id])
    @post = Post.find(params[:id])
  end
end
