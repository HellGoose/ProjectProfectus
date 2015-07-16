class AddNominatedToCampaigns < ActiveRecord::Migration
  def change
  	add_column :campaigns, :nominated, :boolean
  	Campaign.update_all(nominated: false)
  end
end
