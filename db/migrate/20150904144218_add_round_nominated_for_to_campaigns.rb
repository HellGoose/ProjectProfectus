class AddRoundNominatedForToCampaigns < ActiveRecord::Migration
  def change
  	add_column :campaigns, :roundNominatedFor, :integer
  end
end
