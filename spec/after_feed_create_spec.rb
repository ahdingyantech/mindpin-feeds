require 'spec_helper.rb'

class AnswerVoteAfterFeedCreate < ActiveRecord::Base
  self.table_name = 'answer_votes'
  UP = 'UP'
  DOWN = 'DOWN'
  belongs_to :user
  record_feed :scene => :answer_votes,
              :callbacks => [ :create, :update],
              :before_record_feed => lambda {|vote, callback_type|
                if vote.kind == DOWN
                  MindpinFeeds::Feed.destroy_all 
                  return false
                end
                return true
              }
end

describe 'feed 创建回调' do
  before{
    @user = User.create!(:name => "user_1")
    AnswerVoteAfterFeedCreate.create!(:name => "answer_vote", :user => @user, :kind => AnswerVoteAfterFeedCreate::UP)
  }

  it{
    MindpinFeeds::Feed.on_what(:create_answer_vote_after_feed_create).all.count.should == 1
  }

  it{
    MindpinFeeds::Feed.by_user(@user).all.count.should == 1
  }

  describe 'after_feed_create' do
    before{
      AnswerVoteAfterFeedCreate.create!(:name => "answer_vote", :user => @user, :kind => AnswerVoteAfterFeedCreate::DOWN)
    }

    it{
      MindpinFeeds::Feed.count.should == 0
    }
  end
end