require 'spec_helper.rb'

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include MindpinFeeds::RecordFeed

  record_feed :scene => :users,
              :callbacks => [ :update ],
              :set_feed_data => lambda{|user, callback_type|
                if callback_type == :update
                  return user.name
                end
              }
end

describe User do
  before{
    @user = User.create(:name => 'user_f')
  }

  it{
    expect {
      @user.name = 'user_1_gai'
      @user.save!
      @user.name = 'user_1_gai'
      @user.save!
      @user.name = 'user_1_gai1'
      @user.save!
    }.to change{
      MindpinFeeds::Feed.count
    }.by(2)
    MindpinFeeds::Feed.first.data.should == 'user_1_gai1'
  }
end