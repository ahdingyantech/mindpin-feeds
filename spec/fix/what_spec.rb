require 'spec_helper.rb'
class AnswerVote < ActiveRecord::Base
  belongs_to :user
  record_feed :scene => :answer_votes,
              :callbacks => [ :create, :update]
end

describe 'what 的值 不是 create_answervote,而是 create_answer_vote' do
  before{
    @user = User.create!(:name => "user_1")
    AnswerVote.create!(:name => "answer_vote", :user => @user)
  }

  it{
    MindpinFeeds::Feed.on_what(:create_answer_vote).all.count.should == 1
  }

  it{
    MindpinFeeds::Feed.by_user(@user).all.count.should == 1
  }
end