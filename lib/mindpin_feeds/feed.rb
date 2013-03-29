module MindpinFeeds
  class Feed < ActiveRecord::Base
    attr_accessible :who, :scene, :to, :what

    validates :who, :scene, :to, :what, :presence => true

    belongs_to :who, :class_name => 'User', :foreign_key => :user_id
    belongs_to :to, :polymorphic => true

    scope :on_scene, lambda {|scene| { :conditions => ["scene = ?", scene.to_s] }  }
    scope :on_what,  lambda {|what|  { :conditions => ["what = ?", what.to_s] }  } 
    scope :by_user,  lambda {|user|  { :conditions => ['user_id = ?', user.id] }  }
    scope :to,       lambda {|to|    { :conditions => ['to_type = ? and to_id = ?', to.class.name, to.id] }  }
  end
end