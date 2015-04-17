class UpdateCampaignVote < ActiveRecord::Migration
  def change
  	remove_column :campaign_votes, :isDownvote
  	add_column :campaign_votes, :stage, :integer
  	add_column :campaign_votes, :voteType, :integer
  end
end
