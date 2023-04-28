class PostsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @posts = @user.posts.includes(comments: [:author])
  end

  def show
    @post = Post.includes(comments: [:author]).find(params[:id])
  end

  def new
    @post = Post.new
    @post.author_id = current_user.id
  end

  def create
    @post = Post.new(post_params)
    @post.author_id = current_user.id
    respond_to do |format|
      if @post.save
        format.html do
          redirect_to user_post_path(current_user.id, @post.id), notice: 'Post was successfully created.'
        end
      else
        format.html { render :new }
      end
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :text, :comments_counter, :likes_counter)
  end
end
