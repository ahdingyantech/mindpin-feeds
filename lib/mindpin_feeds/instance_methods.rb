module MindpinFeeds
  module InstanceMethods
    def self.included(base)
      if !base.instance_methods.include?(:creator)
        base.define_method :creator do
          self.user
        end
      end
    end
  end
end