require 'mindpin_feeds/callbacks_methods'
require 'mindpin_feeds/without_feed_methods'
require 'mindpin_feeds/feed'
require 'mindpin_feeds/feed_like'

module MindpinFeeds
  module Base
    extend ActiveSupport::Concern

    module ClassMethods
        # record_feed :scene => :questions,
        #       :callbacks => [ :create, :destroy]
      def record_feed(options)
        scene = options[:scene] || self.name.downcase.pluralize
        callbacks = options[:callbacks] || [ :create, :update, :destroy]
        before_record_feed = options[:before_record_feed]

        self.class_variable_set(:@@record_feed_scene, scene) 
        self.class_variable_set(:@@record_feed_callbacks, callbacks)
        self.class_variable_set(:@@record_feed_before_record_feed, before_record_feed)

        self.send(:include, CallbacksMethods)
        self.send(:include, WithoutFeedMethods)

        if record_feed_callbacks.include?(:create)
          self.send(:after_create, :set_feed_on_create)
        end

        if record_feed_callbacks.include?(:update)
          self.send(:after_update, :set_feed_on_update)
        end

        if record_feed_callbacks.include?(:destroy)
          self.send(:after_destroy, :set_feed_on_destroy)
        end
      end

      def record_feed_scene
        self.class_variable_get(:@@record_feed_scene) 
      end

      def record_feed_callbacks
        self.class_variable_get(:@@record_feed_callbacks)
      end

      def record_feed_before_record_feed
        self.class_variable_get(:@@record_feed_before_record_feed)
      end

    end
  end
end


ActiveRecord::Base.send :include, MindpinFeeds::Base