require 'rails_helper'
RSpec.describe UsersController, type: :request do
  describe 'GET /users' do
    it 'returns http success' do
      get '/users'
      expect(response).to have_http_status(:ok)
    end

    it 'renders the index template' do
      get '/users'
      expect(response).to render_template(:index)
    end

    it 'assigns @users' do
      user1 = User.create(name: 'John', photo: 'https://example.com/photo1.jpg', bio: 'Some bio', posts_counter: 0)
      user2 = User.create(name: 'Jane', photo: 'https://example.com/photo2.jpg', bio: 'Some other bio',
                          posts_counter: 0)
      get '/users'
      expect(assigns(:users)).to match_array([user1, user2])
    end

    it 'displays the user profile picture' do
      user = User.create(name: 'John', photo: 'https://example.com/photo1.jpg', bio: 'Some bio', posts_counter: 0)
      get "/users/#{user.id}"
      expect(response.body).to include(user.photo)
    end

    it 'displays the number of posts for the user' do
      user = User.create(name: 'John', photo: 'https://example.com/photo1.jpg', bio: 'Some bio', posts_counter: 5)
      get '/users'
      expect(response.body).to include("Number of posts: #{user.posts_counter}")
    end

    it 'redirects to the user show page when clicking on a user' do
      user = User.create(name: 'John', photo: 'https://example.com/photo1.jpg', bio: 'Some bio', posts_counter: 0)
      get '/users'
      expect(response.body).to include(user_path(user))
      get user_path(user)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /users/:id' do
    it 'returns http success' do
      user = User.create(name: 'John', photo: 'https://example.com/photo1.jpg', bio: 'Some bio', posts_counter: 0)
      get "/users/#{user.id}"
      expect(response).to have_http_status(:ok)
    end

    it 'renders the show template' do
      user = User.create(name: 'John', photo: 'https://example.com/photo1.jpg', bio: 'Some bio', posts_counter: 0)
      get "/users/#{user.id}"
      expect(response).to render_template(:show)
    end

    it 'assigns @user' do
      user = User.create(name: 'John', photo: 'https://example.com/photo1.jpg', bio: 'Some bio', posts_counter: 0)
      get "/users/#{user.id}"
      expect(assigns(:user)).to eq(user)
    end

    it 'displays the user username' do
      user = User.create(name: 'John', photo: 'https://example.com/photo1.jpg', bio: 'Some bio', posts_counter: 0)
      get "/users/#{user.id}"
      expect(response.body).to include(user.name)
    end

    it 'displays the user bio' do
      user = User.create(name: 'John', photo: 'https://example.com/photo1.jpg', bio: 'Some bio', posts_counter: 0)
      get "/users/#{user.id}"
      expect(response.body).to include(user.bio)
    end

    it 'displays the user first 3 posts' do
      user = User.create(name: 'John', photo: 'https://example.com/photo1.jpg', bio: 'Some bio', posts_counter: 5)
      post1 = Post.create(title: 'Post 1', text: 'title of post 1', author_id: user.id)
      post2 = Post.create(title: 'Post 2', text: 'title of post 2', author_id: user.id)
      post3 = Post.create(title: 'Post 3', text: 'title of post 3', author_id: user.id)
      get "/users/#{user.id}"
      expect(response.body).to include(post1.title)
      expect(response.body).to include(post2.title)
      expect(response.body).to include(post3.title)
    end

    it 'displays a button to view all user posts' do
      user = User.create(name: 'John', photo: 'https://example.com/photo1.jpg', bio: 'Some bio', posts_counter: 5)
      get "/users/#{user.id}"
      expect(response.body).to include('see all posts')
    end

    it 'shows link that redirects to post show page when clicking on user post' do
      user = User.create(name: 'John', photo: 'https://example.com/photo1.jpg', bio: 'Some bio', posts_counter: 5)
      post1 = Post.create(title: 'Post 1', text: 'Content of post 1', author_id: user.id)
      get "/users/#{user.id}"
      expect(response.body).to include(post1.title)
    end

    it 'shows link that redirects to user post index page when clicking on "see all posts"' do
      user = User.create(name: 'John', photo: 'https://example.com/photo1.jpg', bio: 'Some bio', posts_counter: 5)
      get "/users/#{user.id}"
      expect(response.body).to include('see all posts')
      expect(response.body).to include(user_posts_path(user))
    end
  end
end
