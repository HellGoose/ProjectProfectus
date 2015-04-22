class RemoveVoteCountFromCampaigns < ActiveRecord::Migration
  def change
    remove_column :campaigns, :voteCount
  end
end
