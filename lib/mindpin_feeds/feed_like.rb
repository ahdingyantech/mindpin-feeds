module MindpinFeeds
  class FeedLike < ActiveRecord::Base
    attr_accessible :user, :feed

    validates :user, :feed, :presence => true

    belongs_to :user
    belongs_to :feed

    scope :by_user, lambda {|user| {:conditions => ['user_id = ?',user.id]} }
  end
end