class LikesController < ApplicationController
    def new
        @like = Like.new
        @current_user = current_user
      end
    
      def create
        @like = Like.new
        @like.author_id = current_user.id
        @post = Post.find(params[:post_id])
        @like.post_id = params[:post_id]
        respond_to do |format|
          format.html do
            if @like.save
              flash[:success] = ' Like created successfully'
              current_post = Post.find(params[:post_id])
              @author = User.find(params[:user_id])
              redirect_to user_post_path(@author, current_post)
            else
              flash[:error] = 'Something went wrong'
              render :new
            end
          end
        end
    end
end