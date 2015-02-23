class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :title
      t.datetime :date
      t.integer :upvotes
      t.integer :downvotes
      t.integer :postCount
      t.belongs_to :forum, index: true
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
    create_join_table :topic, :user, table_name: :topic_votes
  end
end
