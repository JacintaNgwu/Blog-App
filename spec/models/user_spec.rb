require 'rails_helper'

RSpec.describe User, type: :model do
  subject { described_class.new(name: 'Jaccy', bio: 'Full Stack Developer', posts_counter: 0) }

  before { subject.save }

  context 'Validating :name' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a name' do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid if not unique' do
      User.create(name: 'Jay', bio: 'Full Stack Developer', posts_counter: 3)
      subject.name = 'jay'
      expect(subject).to_not be_valid
    end
  end

  context 'validating :posts_counter' do
    it 'is not valid if less than 0' do
      subject.posts_counter = -1
      expect(subject).to_not be_valid
    end

    it 'is not valid if not an integer' do
      subject.posts_counter = 'string'
      expect(subject).to_not be_valid
    end
  end

  describe '#recent_posts' do
    before do
      4.times do |i|
        Post.create(title: "Post#{i + 1}", author: subject, comments_counter: 0, likes_counter: 0)
      end
    end

    it 'returns the 3 most recent posts' do
      expect(subject.recent_posts.length).to eq(3)
    end

    it 'returns the most recent one as first item' do
      expect(subject.recent_posts[0].title).to eq 'Post4'
    end
  end
end
