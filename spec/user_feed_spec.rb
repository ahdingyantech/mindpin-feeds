require 'spec_helper.rb'

class User < ActiveRecord::Base
  self.table_name = 'users'
  record_feed :scene => :users,
              :callbacks => [ :update ]
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
  }
end