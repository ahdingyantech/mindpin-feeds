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

class AnswerVoteMigration < ActiveRecord::Migration
  def self.up
    create_table :answer_votes, :force => true do |t|
      t.string :name
      t.integer :user_id
    end
  end

  def self.down
    drop_table :answer_votes
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

class MigrationHelper
  def self.up
    QuestionMigration.up
    AnswerMigration.up
    UserMigration.up
    MindpinFeedsMigration.up
    AnswerVoteMigration.up
  end

  def self.down
    QuestionMigration.down
    AnswerMigration.down
    UserMigration.down
    MindpinFeedsMigration.down
    AnswerVoteMigration.down
  end
end