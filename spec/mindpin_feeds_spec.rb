require 'spec_helper.rb'


class QuestionMigration < ActiveRecord::Migration
  def self.up
    create_table :questions, :force => true do |t|
      t.string :name
      t.integer :creator_id
    end
  end

  def self.down
    drop_table :questions
  end
end

class AnswerMigration < ActiveRecord::Migration
  def self.up
    create_table :answers, :force => true do |t|
      t.string :name
      t.integer :creator_id
    end
  end

  def self.down
    drop_table :answers
  end
end

class UserMigration < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :users
  end
end

class Question < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User'
  record_feed :scene => :questions,
              :callbacks => [ :create, :destroy]
end

class Answer < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User'
  record_feed :scene => :sui_bian_xie,
              :callbacks => [ :create, :update]
end

class User < ActiveRecord::Base
end

describe MindpinFeeds do
  before(:all){
    QuestionMigration.up
    AnswerMigration.up
    UserMigration.up
    MindpinFeedsMigration.up
  }

  after(:all){
    QuestionMigration.down
    AnswerMigration.down
    UserMigration.down
    MindpinFeedsMigration.down
  }

  describe Question do
    before{
      p User
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

        context '删除 question' do
          before{ @question.destroy }

          it{
            MindpinFeeds::Feed.on_scene(:questions).all.count.should == 2
          }

          it{
            MindpinFeeds::Feed.on_what(:create_question).all.count.should == 1
          }

          it{
            MindpinFeeds::Feed.on_what(:update_question).all.count.should == 0
          }

          it{
            MindpinFeeds::Feed.on_what(:destroy_question).all.count.should == 1
          }

          it{
            MindpinFeeds::Feed.by_user(@user).all.count.should == 2
          }

          it{
            MindpinFeeds::Feed.by_user(@user_1).all.count.should == 0
          }

          it{
            MindpinFeeds::Feed.to(@question).all.count.should == 2
          }
        end
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
            MindpinFeeds::Feed.on_scene(:sui_bian_xie).all.count.should == 2
          }

          it{
            MindpinFeeds::Feed.on_what(:destroy_answer).all.count.should == 0
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

      @question.destroy
      @answer_1.destroy
    }

    # on_scene
    it{
      MindpinFeeds::Feed.on_scene(:questions).all.count.should == 2
    }

    it{
      MindpinFeeds::Feed.on_scene(:sui_bian_xie).all.count.should == 4
    }

    #on_what
    it{
      MindpinFeeds::Feed.on_what(:create_question).all.count.should == 1
      MindpinFeeds::Feed.on_what(:update_question).all.count.should == 0
      MindpinFeeds::Feed.on_what(:destroy_question).all.count.should == 1
    }

    it{
      MindpinFeeds::Feed.on_what(:create_answer).all.count.should == 2
      MindpinFeeds::Feed.on_what(:update_answer).all.count.should == 2
      MindpinFeeds::Feed.on_what(:destroy_answer).all.count.should == 0
    }

    it{
      MindpinFeeds::Feed.by_user(@user).all.count.should == 2
      MindpinFeeds::Feed.by_user(@user_1).all.count.should == 2
      MindpinFeeds::Feed.by_user(@user_2).all.count.should == 2
    }


    it{
      MindpinFeeds::Feed.to(@question).all.count.should == 2
      MindpinFeeds::Feed.to(@answer_1).all.count.should == 2
      MindpinFeeds::Feed.to(@answer_2).all.count.should == 2
    }
  end
end

