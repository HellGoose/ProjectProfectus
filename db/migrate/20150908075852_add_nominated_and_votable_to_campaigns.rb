class AddNominatedAndVotableToCampaigns < ActiveRecord::Migration
  def change
  	add_column :campaigns, :nominated, :boolean
  	add_column :campaigns, :votable, :boolean
  end
end
