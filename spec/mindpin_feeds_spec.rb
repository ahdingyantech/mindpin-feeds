require 'spec_helper.rb'

class Question
  include Mongoid::Document
  include Mongoid::Timestamps
  include MindpinFeeds::RecordFeed

  field :name,      :type => String
  belongs_to :creator, :class_name => 'User'
  record_feed :scene => :questions,
              :callbacks => [ :create]
end

class Answer
  include Mongoid::Document
  include Mongoid::Timestamps
  include MindpinFeeds::RecordFeed

  field :name,      :type => String
  belongs_to :creator, :class_name => 'User'
  record_feed :scene => :sui_bian_xie,
              :callbacks => [ :create, :update]
end

describe MindpinFeeds do

  describe Question do
    before{
      @user = User.create!(:name => 'user')
      @user_1 = User.create!(:name => 'user_1')
    }

    it{
      MindpinFeeds::Feed.on_scene(:questions).all.count.should == 0
    }

    it{
      MindpinFeeds::Feed.on_what(:create_question).all.count.should == 0
    }

    it{
      MindpinFeeds::Feed.by_user(@user).all.count.should == 0
    }

    it{
      MindpinFeeds::Feed.to(@user).all.count.should == 0
    }

    context '增加一个 question' do
      before{
        @question = Question.create(:name => "question_1", :creator => @user)
      }

      it{
        MindpinFeeds::Feed.on_scene(:questions).all.count.should == 1
      }

      it{
        MindpinFeeds::Feed.on_what(:create_question).all.count.should == 1
      }

      it{
        MindpinFeeds::Feed.by_user(@user).all.count.should == 1
      }

      it{
        MindpinFeeds::Feed.to(@question).all.count.should == 1
      }
      context '更新 question' do
        before{
          @question.name = "question_gai"
          @question.save!
        }

        it{
          MindpinFeeds::Feed.on_scene(:questions).all.count.should == 1
        }

        it{
          MindpinFeeds::Feed.on_what(:update_question).all.count.should == 0
        }

      end


    end

  end

  describe Answer do
    before{
      @user = User.create!(:name => 'user')
      @user_1 = User.create!(:name => 'user_1')
    }

    it{
      MindpinFeeds::Feed.on_scene(:sui_bian_xie).all.count.should == 0
    }

    it{
      MindpinFeeds::Feed.on_what(:create_answer).all.count.should == 0
    }

    it{
      MindpinFeeds::Feed.by_user(@user).all.count.should == 0
    }

    it{
      MindpinFeeds::Feed.to(@user).all.count.should == 0
    }

    context '创建 answer' do
      before{
        @answer = Answer.create!(:name => "answer_1", :creator => @user)
      }

      it{
        MindpinFeeds::Feed.on_scene(:sui_bian_xie).all.count.should == 1
      }

      it{
        MindpinFeeds::Feed.on_what(:create_answer).all.count.should == 1
      }

      it{
        MindpinFeeds::Feed.by_user(@user).all.count.should == 1
      }

      it{
        MindpinFeeds::Feed.to(@answer).all.count.should == 1
      }

      context '更新 answer' do
        before{
          @answer.name = 'answer_gai'
          @answer.save!
        }

        it{
          MindpinFeeds::Feed.on_scene(:sui_bian_xie).all.count.should == 2
        }

        it{
          MindpinFeeds::Feed.on_what(:create_answer).all.count.should == 1
        }

        it{
          MindpinFeeds::Feed.on_what(:update_answer).all.count.should == 1
        }

        it{
          MindpinFeeds::Feed.by_user(@user).all.count.should == 2
        }

        it{
          MindpinFeeds::Feed.by_user(@user_1).all.count.should == 0
        }

        it{
          MindpinFeeds::Feed.to(@answer).all.count.should == 2
        }

        context '删除 answer' do
          before{
            @answer.destroy
          }

          it{
            MindpinFeeds::Feed.on_scene(:sui_bian_xie).all.count.should == 0
          }
        end
      end
    end
  end

  describe '多个混合操作' do
    before{
      @user = User.create!(:name => 'user')
      @user_1 = User.create!(:name => 'user_1')
      @user_2 = User.create!(:name => 'user_2')

      @question = Question.create!(:name => 'question', :creator => @user)

      @answer_1 = Answer.create!(:name => 'answer_1', :creator => @user_1)
      @answer_2 = Answer.create!(:name => 'answer_1', :creator => @user_2)

      @question.name = 'question_gai'
      @question.save!

      @answer_1.name = "answer_1_gai"
      @answer_1.save!

      @answer_2.name = "answer_2_gai"
      @answer_2.save!
    }

    # on_scene
    it{
      MindpinFeeds::Feed.on_scene(:questions).all.count.should == 1
    }

    it{
      MindpinFeeds::Feed.on_scene(:sui_bian_xie).all.count.should == 4
    }

    #on_what
    it{
      MindpinFeeds::Feed.on_what(:create_question).all.count.should == 1
      MindpinFeeds::Feed.on_what(:update_question).all.count.should == 0
    }

    it{
      MindpinFeeds::Feed.on_what(:create_answer).all.count.should == 2
      MindpinFeeds::Feed.on_what(:update_answer).all.count.should == 2
    }

    it{
      MindpinFeeds::Feed.by_user(@user).all.count.should == 1
      MindpinFeeds::Feed.by_user(@user_1).all.count.should == 2
      MindpinFeeds::Feed.by_user(@user_2).all.count.should == 2
    }


    it{
      MindpinFeeds::Feed.to(@question).all.count.should == 1
      MindpinFeeds::Feed.to(@answer_1).all.count.should == 2
      MindpinFeeds::Feed.to(@answer_2).all.count.should == 2
    }
  end

  describe '点赞' do
    before{
      @creator = User.create!(:name => 'creator')
      @user_1  = User.create!(:name => 'user_1')
      @user_2  = User.create!(:name => 'user_2')
      Question.create(:name => "question_1", :creator => @creator)
      Question.create(:name => "question_2", :creator => @creator)
      
      feeds = MindpinFeeds::Feed.by_user(@creator)
      @feed_1 = feeds[0]
      @feed_2 = feeds[1]
    }

    it{
      @feed_1.like_count.should == 0
    }

    it{
      @feed_1.like_by?(@user_1).should == false
    }

    it{
      @feed_1.like_by?(@user_2).should == false
    }

    context '点赞' do
      before{
        @feed_1.liked(@user_1)
      }

      it{
        @feed_1.like_count.should == 1
      }

      it{
        @feed_1.like_by?(@user_1).should == true
      }
      context '取消点赞' do
        before{
          @feed_1.cancel_like(@user_1)
        }

        it{
          @feed_1.like_count.should == 0
        }

        it{
          @feed_1.like_by?(@user_1).should == false
        }
      end

      context '复杂情况' do
      end
    end
  end

  describe 'without_feed' do
    before{
      @user = User.create!(:name => 'user')
      @answer = Answer.create!(:name => "answer_1", :creator => @user)
    }

    it{
      MindpinFeeds::Feed.by_user(@user).all.count.should == 1
    }


    it{
      @answer.without_feed do
        @answer.name = 'answer_gai_1'
        @answer.save
      end
      MindpinFeeds::Feed.by_user(@user).all.count.should == 1
    }
  end

  describe '不连续给同一个用户创建相同的 feed' do
    before{
      @user = User.create!(:name => 'user')
      @answer = Answer.create!(:name => "answer_1", :creator => @user)
    }

    it{
      MindpinFeeds::Feed.by_user(@user).all.count.should == 1
    }

    context '第一次修改 answer' do
      before{
        @answer.name = 'answer_gai_1'
        @answer.save
      }

      it{
        MindpinFeeds::Feed.by_user(@user).all.count.should == 2
      }

      context '第二次修改 answer' do
        before{
          @answer.name = 'answer_gai_2'
          @answer.save
        }

        it{
          MindpinFeeds::Feed.by_user(@user).all.count.should == 2
        }

        context '做其他操作' do
          before{
            Answer.create!(:name => "answer_2", :creator => @user)
          }

          it{
            MindpinFeeds::Feed.by_user(@user).all.count.should == 3
          }

          context '第三次修改 answer' do
            before{
              @answer.name = 'answer_gai_3'
              @answer.save
            }

            it{
              MindpinFeeds::Feed.by_user(@user).all.count.should == 4
            }
          end
        end
      end
    end
  end

end

