require 'spec_helper.rb'

class User < ActiveRecord::Base
  self.table_name = 'users'
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
    }.to change{
      MindpinFeeds::Feed.count
    }.by(1)
    MindpinFeeds::Feed.last.data.should == 'user_1_gai'
  }
end