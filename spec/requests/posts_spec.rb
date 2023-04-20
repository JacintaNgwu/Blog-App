require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe 'GET /index' do
    before :each do
      @user = User.create(
        name: 'Rick',
        photo: 'RickPhoto.jpg',
        bio: 'Mortys awesome grandfather!',
        posts_counter: 1
      )
      get "/users/#{@user.id}/posts"
    end

    it 'Returns a http success status' do
      expect(response).to have_http_status(:ok)
    end
    it 'Should render the index template' do
      expect(response).to render_template(:index)
    end

    it 'Should include the correct placeholder text' do
      expect(response.body).to include('Here is a list of all the post')
    end
  end

  describe 'GET /show' do
    before :each do
      @user = User.create(
        name: 'Morty',
        bio: 'Ricks nephew',
        posts_counter: 1
      )
      @post = Post.create(
        author: @user,
        title: 'Hello',
        text: 'This is my first post',
        author_id: @user.id,
        comments_counter: 0,
        likes_counter: 0
      )
      get "/users/#{@user.id}/posts/#{@post.id}"
    end

    it 'Returns a http success status' do
      expect(response).to have_http_status(:ok)
    end

    it 'Should render the show template' do
      expect(response).to render_template(:show)
    end

    it 'Should include the correct placeholder text' do
      expect(response.body).to include('Here is a specific post')
    end
  end
end