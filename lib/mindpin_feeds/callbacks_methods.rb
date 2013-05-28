module MindpinFeeds
  module CallbacksMethods
    def set_feed_on_create
      __set_feed_on_commit('create')
    end

    def set_feed_on_update
      __set_feed_on_commit('update')
    end

    def set_feed_on_destroy
      __set_feed_on_commit('destroy')
    end

    def __set_feed_on_commit(callback_name)
      return true if self.without_feed_flag

      proc = self.class.record_feed_before_record_feed
      if proc.is_a?(Proc)
        bool = proc.call(self, callback_name.to_sym)
        return true if !bool
      end

      if self.respond_to?(:creator)
        user = self.creator
      elsif self.respond_to?(:user)
        user = self.user
      elsif self.class.name == 'User'
        user = self
      end

      feed = MindpinFeeds::Feed.create :who => user,
                :scene => self.class.record_feed_scene.to_s,
                :to => self,
                :what => "#{callback_name}_#{self.class.to_s.underscore}"

    rescue Exception => ex
      p "警告: #{self.class} feed 创建失败"
      puts ex.message
      puts ex.backtrace*"\n"
    end
  end
end