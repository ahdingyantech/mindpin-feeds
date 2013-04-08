module MindpinFeeds
  module WithoutFeedMethods
    def without_feed
      self.without_feed_flag = true
      yield
      self.without_feed_flag = false
    end

    def without_feed_flag=(flag)
      @without_feed_flag = flag
    end

    def without_feed_flag
      @without_feed_flag ||= false
    end
  end
end
