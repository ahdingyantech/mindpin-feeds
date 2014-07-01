require 'spec_helper.rb'

class AnswerVoteAddCeator
  include Mongoid::Document
  include Mongoid::Timestamps
  include MindpinFeeds::RecordFeed
  field :name,      :type => String
  belongs_to :user
  record_feed :scene => :answer_votes,
              :callbacks => [ :create, :update]
end

class AnswerVoteUnAddCeator
  include Mongoid::Document
  include Mongoid::Timestamps
  include MindpinFeeds::RecordFeed
  field :name,      :type => String
  belongs_to :user
  record_feed :scene => :answer_votes,
              :callbacks => [ :create, :update]

  def creator
    User.create!(:name => "自定义方法")
  end
end

describe do
  it 'feed add creator' do
    user = User.create!(:name => "user_1")
    vote = AnswerVoteAddCeator.create!(:name => "answer_vote", :user => user)
    vote.creator.should == user
    vote.user.should == user
  end

  it "feed unadd creator" do
    user = User.create!(:name => "user_1")
    vote = AnswerVoteUnAddCeator.create!(:name => "answer_vote", :user => user)
    vote.creator.name.should == "自定义方法"
    vote.user.should == user
  end
end
