require 'rails_helper'

RSpec.describe Post, type: :model do
  let!(:user) { User.create(name: 'Eby', bio: 'Dancer', posts_counter: 0) }
  subject do
    described_class.new(title: 'Post 1', text: 'This is my blog', author: user, comments_counter: 0, likes_counter: 0)
  end

  before { subject.save }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a title' do
      subject.title = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid if title is longer than 250' do
      subject.title = 'a' * 251
      expect(subject).to_not be_valid
    end

    it 'is not valid if likes_counter is less than 0' do
      subject.likes_counter = -1
      expect(subject).to_not be_valid
    end

    it 'is not valid if likes_counter is not an integer' do
      subject.likes_counter = 'string'
      expect(subject).to_not be_valid
    end

    it 'is not valid if comments_counter is less than 0' do
      subject.comments_counter = -1
      expect(subject).to_not be_valid
    end

    it 'is not valid if comments_counter is not an integer' do
      subject.comments_counter = 'string'
      expect(subject).to_not be_valid
    end
  end

  describe 'associations' do
    it 'belongs to an author' do
      expect(subject.author).to eq(user)
    end

    it 'updates counter of author' do
      expect(user.posts_counter).to eq(1)
    end
  end

  describe '#recent_comments' do
    before do
      6.times do |i|
        Comment.create(text: "Comment #{i + 1}", post: subject, author: user)
      end
    end

    it 'returns the 5 most recent comments' do
      expect(subject.recent_comments.length).to eq(5)
    end

    it 'returns the most recent comments' do
      expect(subject.recent_comments.first).to eq(subject.comments.last)
    end
  end
end
