module MindpinFeeds
  class FeedLike
    include Mongoid::Document
    include Mongoid::Timestamps

    validates :user, :feed, :presence => true
    validates :user_id, :uniqueness => {:scope => :feed_id}

    belongs_to :user
    belongs_to :feed

    scope :by_user, ->(user) { where(:user_id => user.id) }
  end
end