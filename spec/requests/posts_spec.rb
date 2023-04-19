require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe 'GET #index' do
    before(:each) do
      user1 = User.create(name: 'Jacinta Ngwu', photo: 'https://picsum.photos/200/300', bio: 'Full Stack Developer',
                          posts_counter: 6)
      user2 = User.create(name: 'John Doe', photo: 'https://picsum.photos/200/300', bio: 'Full Stack Developer',
                          posts_counter: 6)
      Post.create(title: 'Post 1', text: 'This is post 1', author: user1)
      Post.create(title: 'Post 2', text: 'This is post 2', author: user2)
    end
    before(:example) { get user_posts_path(user_id: 1) }


    it 'Should returns http success status' do
      expect(response).to have_http_status(:ok)
    end

    it 'Should render the index template' do
      expect(response).to render_template(:index)
    end

    it 'includes correct placeholder text' do
      get user_posts_path(1)
      expect(response.body).to include('<h1>Here is a list of all the posts</h1>')
    end
  end

  describe 'GET #show' do
    before(:example) { get user_posts_path(user_id: 1, id: 1) }

    it 'Should returns http success status' do
      expect(response).to have_http_status(:ok)
    end

    it 'Should response includes placeholder text' do
      expect(response.body).to include('<h1>Here is a list of all the posts</h1>')
    end
  end
end
