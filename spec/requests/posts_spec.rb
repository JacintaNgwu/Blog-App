# require 'rails_helper'

# RSpec.describe 'Posts', type: :request do
#   describe 'GET /index' do
#     before :each do
#       @user = User.create(
#         name: 'Rick',
#         photo: 'RickPhoto.jpg',
#         bio: 'Mortys awesome grandfather!',
#         posts_counter: 1
#       )
#       get "/users/#{@user.id}/posts"
#     end

#     it 'Returns a http success status' do
#       expect(response).to have_http_status(:ok)
#     end
#     it 'Should render the index template' do
#       expect(response).to render_template(:index)
#     end

#     it 'Should include the correct placeholder text' do
#       expect(response.body).to include('Here is a list of all the post')
#     end
#   end

#   describe 'GET /show' do
#     before :each do
#       @user = User.create(
#         name: 'Morty',
#         bio: 'Ricks nephew',
#         posts_counter: 1
#       )
#       @post = Post.create(
#         author: @user,
#         title: 'Hello',
#         text: 'This is my first post',
#         author_id: @user.id,
#         comments_counter: 0,
#         likes_counter: 0
#       )
#       get "/users/#{@user.id}/posts/#{@post.id}"
#     end

#     it 'Returns a http success status' do
#       expect(response).to have_http_status(:ok)
#     end

#     it 'Should render the show template' do
#       expect(response).to render_template(:show)
#     end

#     it 'Should include the correct placeholder text' do
#       expect(response.body).to include('Here is a specific post')
#     end
#   end
# end


require 'rails_helper'
RSpec.describe 'Post show page', type: :feature do
  before :each do
    @user1 = User.create(name: 'Tom', photo: 'https://picsum.photos/300/300', bio: 'Software Engineer from Nigeria')
    @user2 = User.create(name: 'Daniel', photo: 'https://picsum.photos/200/400', bio: 'Software Engineer from Nigeria')
    @post1 = Post.create(author: @user1, title: 'Great', text: 'Hello World!')
    Comment.create(author: @user1, post: @post1, text: 'it is not 3 pm yet and already I have had a day')
    Comment.create(author: @user1, post: @post1, text: 'what a post!')
    Like.create(author: @user1, post: @post1)
    Like.create(author: @user2, post: @post1)
    visit user_post_path(@user2, @post1)
  end
  it "show the post's title" do
    expect(page).to have_content(@post1.title)
  end
  it 'Show who wrote the post' do
    expect(page).to have_content(@post1.author.name)
  end
  it 'displays the comment count and like count' do
    expect(page).to have_content('Comments:2 likes:2')
  end
  it 'Show the post body' do
    expect(page).to have_content(@post1.text)
  end
  it 'Show the username of each commentor' do
    @post1.comments.each do |comment|
      expect(page).to have_content(comment.author.name)
    end
  end
  it 'Show the comment each commentor left' do
    @post1.comments.each do |comment|
      expect(page).to have_content(comment.text)
    end
  end
end

RSpec.describe 'Posts index ', type: :feature do
  before do
    @user1 = User.create(name: 'Ellon', photo: 'https://picsum.photos/300/200', bio: 'Software Engineer from Migingo')
    @user2 = User.create(name: 'Hassan', photo: 'https://picsum.photos/200/300', bio: 'Software Engineer from Uganda')
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

  it "displays post's title" do
    expect(page).to have_content(@post1.title)
    expect(page).to have_content(@post2.title)
  end
  it "displays some of the post's body" do
    expect(page).to have_content(@post1.text)
    expect(page).to have_content(@post1.text)
  end
  it 'displays first comments on a post' do
    expect(page).to have_content(@comment1.author.name)
    expect(page).to have_content(@comment1.text)
  end

  it "When I click on a post, it redirects me to that post's show page" do
    click_link('Howdy')
    expect(page).to have_current_path(user_post_path(@user1, @post2))
  end
end