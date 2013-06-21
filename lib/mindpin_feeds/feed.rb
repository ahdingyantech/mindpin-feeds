module MindpinFeeds
  class Feed < ActiveRecord::Base
    attr_accessible :who, :scene, :to, :what, :data

    validates :who, :scene, :to, :what, :presence => true

    belongs_to :who, :class_name => 'User', :foreign_key => :user_id
    belongs_to :to, :polymorphic => true

    scope :on_scene, lambda {|scene| { :conditions => ["scene = ?", scene.to_s] }  }
    scope :on_what,  lambda {|what|  { :conditions => ["what = ?", what.to_s] }  } 
    scope :by_user,  lambda {|user|  { :conditions => ['user_id = ?', user.id] }  }
    scope :to,       lambda {|to|    { :conditions => ['to_type = ? and to_id = ?', to.class.name, to.id] }  }

    default_scope :order => 'id desc'

    has_many :feed_likes

    validate :validate_repeat_feed
    def validate_repeat_feed
      newest_feed = MindpinFeeds::Feed.by_user(self.who).first
      return true if newest_feed.blank?
      bool_1 = (newest_feed.who == self.who)
      bool_2 = (newest_feed.scene == self.scene)
      bool_3 = (newest_feed.to == self.to)
      bool_4 = (newest_feed.what == self.what)
      if bool_1 && bool_2 && bool_3 && bool_4
        errors.add(:base,'重复的 feed')
      end
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