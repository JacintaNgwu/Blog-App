require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET #index' do
    it 'returns a success response' do
      get users_path
      expect(response).to be_successful
    end

    it 'renders the index template' do
      get users_path
      expect(response).to render_template(:index)
    end

    it 'includes correct placeholder text' do
      get user_posts_path(1, 1)
      expect(response.body).to include('<h1>Here is a list of all the posts</h1>')
    end
  end

  describe 'GET #show' do
    let(:user) { User.create(name: 'Jacinta Ezinwa', photo: 'https://picsum.photos/200/300', bio: 'Full Stack Developer', posts_counter: 6) }

    it 'returns a success response' do
      get user_path(id: user.id)
      expect(response).to be_successful
    end

    it 'renders the show template' do
      get user_path(id: user.id)
      expect(response).to render_template(:show)
    end

    it 'includes correct placeholder text' do
      get user_posts_path(1, 1)
      expect(response.body).to include('<h1>Here is a list of all the posts</h1>')
    end
  end
end
