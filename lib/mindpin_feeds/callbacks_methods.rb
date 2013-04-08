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

      MindpinFeeds::Feed.create :who => self.creator,
                :scene => self.class.record_feed_scene,
                :to => self,
                :what => "#{callback_name}_#{self.class.to_s.downcase}"
    end
  end
end