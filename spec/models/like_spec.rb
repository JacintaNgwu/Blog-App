require 'rails_helper'

RSpec.describe Like, type: :model do
  let!(:user) { User.create(name: 'Ezy', bio: 'Officer', posts_counter: 0) }
  let!(:post) do
    Post.create(title: 'My Blog', text: 'Be safe.', author: user, comments_counter: 0, likes_counter: 0)
  end
  subject { described_class.create(author: user, post:) }

  describe 'associations' do
    it 'belongs to an author' do
      expect(subject.author).to eql(user)
    end

    it 'belongs to a post' do
      expect(subject.post).to eql(post)
    end

    it 'updates counter of post' do
      expect(subject.post.likes_counter).to eql(1)
    end
  end
end
