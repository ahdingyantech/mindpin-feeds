module MindpinFeeds
  class Feed
    include Mongoid::Document
    include Mongoid::Timestamps

    field :scene,      :type => String
    field :what,       :type => String
    field :data,       :type => String

    belongs_to :who, :class_name => 'User', :foreign_key => :user_id
    belongs_to :to, :polymorphic => true

    validates :who, :scene, :to, :what, :presence => true

    scope :on_scene, ->(scene){  where(:scene => scene.to_s) }
    scope :on_what,  ->(what){   where(:what => what.to_s) }
    scope :by_user,  ->(user){   where(:user_id => user.id.to_s) }
    scope :to,       ->(to){     where(:to_type => to.class.name, :to_id => to.id.to_s) }

    default_scope ->{order_by("id DESC")}

    has_many :feed_likes

    def self.validate_repeat_feed(feed)
      newest_feed = MindpinFeeds::Feed.by_user(feed.who).first
      return true if newest_feed.blank?
      bool_1 = (newest_feed.who == feed.who)
      bool_2 = (newest_feed.scene == feed.scene)
      bool_3 = (newest_feed.to == feed.to)
      bool_4 = (newest_feed.what == feed.what)
      bool_5 = (newest_feed.data.to_s == feed.data.to_s)
      return !(bool_1 && bool_2 && bool_3 && bool_4 && bool_5)
    end

    def like_count
      self.feed_likes.count
    end

    def liked(user)
      return if self.like_by?(user)
      self.feed_likes.create!(:user => user)
    end

    def cancel_like(user)
      self.feed_likes.by_user(user).each do |like|
        like.destroy
      end
    end

    def like_by?(user)
      self.feed_likes.by_user(user).present?
    end
  end
end