mindpin-feeds
=============

# 配置

```
# Gemfile
gem 'mindpin-feeds',
    :git => 'git://github.com/mindpin/mindpin-feeds',
    :tag => '1.0.1'
```


# 增加声明
```ruby
class Answer
  include Mongoid::Document
  include Mongoid::Timestamps
  include MindpinFeeds::RecordFeed
  
  record_feed :scene => :sui_bian_xie,
              :callbacks => [ :create, :update ]
end
```

# 跳过 feed 创建
```ruby
answer = Answer.last

answer.without_feed do
  answer.update_attributes(:content => "blanblanblan改")
end
```


# 查询
```ruby
MindpinFeeds::Feed.on_scene(:sui_bian_xie
MindpinFeeds::Feed.on_what(:create_answer).all
MindpinFeeds::Feed.on_what(:update_answer).all
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

