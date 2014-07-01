require 'spec_helper.rb'

class QuestionDependent
  include Mongoid::Document
  include Mongoid::Timestamps
  include MindpinFeeds::RecordFeed
  field :name,      :type => String
  belongs_to :creator, :class_name => 'User'
  record_feed :scene => :questions,
              :callbacks => [ :create ]
end

describe '创建' do
  before{
    @user = User.create!(:name => "user_1")
    @question_1 = QuestionDependent.create!(:name => "questions_1", :creator => @user)
    @question_2 = QuestionDependent.create!(:name => "questions_2", :creator => @user)
  }

  it{
    MindpinFeeds::Feed.count.should == 2
  }

  it{
    @question_2.feeds.count.should == 1
  }

  describe '级联删除' do
    before{
      @question_2.destroy
    }

    it{
      MindpinFeeds::Feed.count.should == 1
    }

  end
end