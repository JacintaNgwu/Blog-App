class UsersController < ApplicationController
  def index
    @users = User.all
    @posts = @user.posts
  end

  def show
    @user = User.find(params[:id])
    @recent_posts = @user.recent_posts
  end
end
