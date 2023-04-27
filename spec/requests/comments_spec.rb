require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  describe 'GET /show' do
    before(:example) do
      @user = User.create(name: 'Tom',
                          photo: 'https://picsum.photos/200/500',
                          bio: 'Teacher from Mexico', posts_counter: 0)

      @post1 = Post.create(author: @user, title: 'Timmy Jimmy', text: 'Hey Jimmy jimmy', likes_counter: 0,
                           comments_counter: 0)

      @comment1 = Comment.create(author: @user, post: @post1, text: 'Hi guys')
      @comment2 = Comment.create(author: @user, post: @post1, text: 'Hey')
      @comment3 = Comment.create(author: @user, post: @post1, text: 'Hope you are doing well')
    end

    it 'returns http success' do
      get "/users/#{@user.id}/posts/#{@post1.id}",
          params: { id: @comment1.id }, xhr: true
      expect(response).to have_http_status(:success)
    end
  end
end