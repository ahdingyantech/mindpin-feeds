module MindpinFeeds
  module InstanceMethods
    def self.included(base)
      base.has_many :feeds, :class_name => 'MindpinFeeds::Feed', :as => :to, :dependent => :destroy
      if !base.instance_methods.include?(:creator)
        base.send(:define_method,:creator) do
          self.user
        end
      end
    end
  end
end