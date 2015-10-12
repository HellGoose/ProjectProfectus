class AddTimesSeenToCampaign < ActiveRecord::Migration
  def change
  	add_column :campaigns, :timesShownInVoting, :integer
  end
end
