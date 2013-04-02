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