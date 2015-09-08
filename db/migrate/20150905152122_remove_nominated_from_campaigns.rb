class RemoveNominatedFromCampaigns < ActiveRecord::Migration
  def change
  	remove_column :campaigns, :nominated
  end
end
