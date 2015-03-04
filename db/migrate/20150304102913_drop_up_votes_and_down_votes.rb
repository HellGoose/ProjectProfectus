class DropUpVotesAndDownVotes < ActiveRecord::Migration
  def change
  	add_column :posts, :voteCount, :integer
  	add_column :topics, :voteCount, :integer
  	remove_column :topics, :postCount
  	remove_column :forums, :postCount
  	remove_column :forums, :topicCount
  end
end
