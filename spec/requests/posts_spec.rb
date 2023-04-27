require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  subject do
    User.create(name: 'Ali Khan', photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                bio: 'Researcher from UK.', posts_counter: 0)
  end

  describe 'GET /index' do
    before(:each) do
      get "/users/#{subject.id}/posts"
    end

    it 'Users index is successful' do
      expect(response).to have_http_status(:ok)
    end
    it 'Renders template correctly' do
      expect(response).to render_template(:index)
    end

    it 'Response should include right placeholder text' do
      expect(response.body).to include('Here is a list of all the post')
    end
  end

  describe 'Show single user details' do
    before(:each) do
      user = User.create(name: 'Jacinta Ezinwe', photo: 'https://unsplash.com/photos/F_-0BxGuVvo',
                         bio: 'Researcher from UK.', posts_counter: 0)

      new_post = Post.create(author: user, title: 'Hello', text: 'This is my first post', likes_counter: 0,
                             comments_counter: 0)
      get "/users/#{user.id}/posts/#{new_post.id}"
    end

    it 'Response will be successful.' do
      expect(response).to have_http_status(:ok)
    end
    it 'Template render correctly' do
      expect(response).to render_template(:show)
    end
    it 'Response should include right placeholder text.' do
      expect(response.body).to include('Here is a specific post')
    end
  end
end

RSpec.describe 'Posts index ', type: :feature do
  before do
    @user1 = User.create(name: 'Ellon', photo: 'https://picsum.photos/300/200',
                         bio: 'Software Engineer from Migingo')
    @user2 = User.create(name: 'Hassan', photo: 'https://picsum.photos/200/300',
                         bio: 'Software Engineer from Uganda')
    @post1 = Post.create(author: @user1, title: 'Great', text: 'Hello World!')
    @post2 = Post.create(author: @user1, title: 'Howdy', text: 'This is test post.')
    @comment1 = Comment.create(author: @user1, post: @post1, text: 'Today is sunny and calm')
    Comment.create(author: @user1, post: @post1, text: 'Very good, lets go and Enjoy!')
    visit user_posts_path(@user1)
  end
  it "displays user's profile picture" do
    expect(page).to have_css('img')
  end
  it "displays user's username" do
    expect(page).to have_content(@user1.name)
  end

  it "When I click on a post, it redirects me to that post's show page" do
    click_link('Howdy')
    expect(page).to have_current_path(user_post_path(@user1, @post2))
  end
end

RSpec.describe 'Post show page', type: :feature do
  let(:user1) { User.create(name: 'Tom', photo: 'https://picsum.photos/300/300', bio: 'Software Engineer from Nigeria') }
  let(:user2) { User.create(name: 'Daniel', photo: 'https://picsum.photos/200/400', bio: 'Software Engineer from Nigeria') }
  let(:post1) { Post.create(author: user1, title: 'Great', text: 'Hello World!') }

  before do
    Comment.create(author: user1, post: post1, text: 'it is not 3 pm yet and already I have had a day')
    Comment.create(author: user1, post: post1, text: 'what a post!')
    Like.create(author: user1, post: post1)
    Like.create(author: user2, post: post1)
  end

  shared_examples 'renders correctly' do
    it "shows the post's title" do
      expect(page).to have_content(post1.title)
    end

    it 'shows who wrote the post' do
      expect(page).to have_content(post1.author.name)
    end

    it 'displays the comment count and like count' do
      expect(page).to have_content('Comments: 2 likes: 2')
    end

    it 'shows the post body' do
      expect(page).to have_content(post1.text)
    end

    it 'shows the username of each commentor' do
      post1.comments.each do |comment|
        expect(page).to have_content(comment.author.name)
      end
    end

    it 'shows the comment each commentor left' do
      post1.comments.each do |comment|
        expect(page).to have_content(comment.text)
      end
    end
  end
end
