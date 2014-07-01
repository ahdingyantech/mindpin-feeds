require 'spec_helper.rb'

class AnswerVoteIf
  include Mongoid::Document
  include Mongoid::Timestamps
  include MindpinFeeds::RecordFeed
  
  UP = 'UP'
  DOWN = 'DOWN'
  field :name,      :type => String
  field :kind,      :type => String
  belongs_to :user
  record_feed :scene => :answer_votes,
              :callbacks => [ :create, :update],
              :before_record_feed => lambda {|vote, callback_type|
                return vote.kind == UP && callback_type == :create
              }
end

describe '条件创建' do
  before{
    @user = User.create!(:name => "user_1")
    AnswerVoteIf.create!(:name => "answer_vote", :user => @user, :kind => AnswerVoteIf::DOWN)
  }

  it{
    MindpinFeeds::Feed.on_what(:create_answer_vote).all.count.should == 0
  }

  it{
    MindpinFeeds::Feed.by_user(@user).all.count.should == 0
  }

  describe '符合 if' do
    before{
      AnswerVoteIf.create!(:name => "answer_vote", :user => @user, :kind => AnswerVoteIf::UP)
    }

    it{
      MindpinFeeds::Feed.on_what(:create_answer_vote_if).all.count.should == 1
    }

    it{
      MindpinFeeds::Feed.by_user(@user).all.count.should == 1
    }
  end
end