class UpdateCampaignVote < ActiveRecord::Migration
  def change
  	asdasdadad
  	remove_column :campaign_votes, :isDownvote
  	add_column : :campaign_votes, :points, :integer

  end
end
