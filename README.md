mindpin-feeds
=============

# 配置

```
gem 'mindpin-feeds',
    :git => 'git://github.com/mindpin/mindpin-feeds'
```


# 增加 migration
```ruby
class MindpinFeedsMigration < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.integer :user_id
      t.string  :scene

      t.integer :to_id
      t.string :to_type

      t.string :what
      t.timestamps
    end
    
    create_table :feed_likes do |t|
      t.integer :user_id
      t.integer :feed_id
      t.timestamps
    end
  end

  def self.down
    drop_table :feeds
    drop_table :feed_likes
  end
end
```

# 增加声明
```ruby
class Answer < ActiveRecord::Base
  
  record_feed :scene => :sui_bian_xie,
              :callbacks => [ :create, :update, :destroy]
end
```


# 查询
```ruby
MindpinFeeds::Feed.on_scene(:sui_bian_xie
MindpinFeeds::Feed.on_what(:create_answer).all
MindpinFeeds::Feed.on_what(:update_answer).all
MindpinFeeds::Feed.on_what(:destroy_answer).all
MindpinFeeds::Feed.by_user(@user).all
MindpinFeeds::Feed.to(@answer).all
```

# 赞
```ruby
feed = MindpinFeeds::Feed.last
feed.like_count
feed.liked(user)
feed.cancel_like(user)
feed.like_by?(user)
```

```

