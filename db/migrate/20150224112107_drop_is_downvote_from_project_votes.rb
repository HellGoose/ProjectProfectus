class DropIsDownvoteFromProjectVotes < ActiveRecord::Migration
  def change
  	remove_column :project_votes, :isDownvote
  	remove_column :posts, :date
  	remove_column :topics, :date
  end
end
