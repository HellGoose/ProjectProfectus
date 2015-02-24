class CreateTopicVotes < ActiveRecord::Migration
  def change
    drop_table :topic_votes
	create_table :topic_votes do |t|
		t.belongs_to :user, index: true
		t.belongs_to :topic, index: true
		t.boolean :isDownvote
		t.timestamps null: false
	end
  end
end
