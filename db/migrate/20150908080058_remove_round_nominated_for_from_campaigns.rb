class RemoveRoundNominatedForFromCampaigns < ActiveRecord::Migration
  def change
  	remove_column :campaigns, :roundNominatedFor
  end
end
