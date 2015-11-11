class CampaignChanges < ActiveRecord::Migration
	def change
		change_column :campaigns, :pledged, :string
		change_column :campaigns, :goal, :string
		remove_column :campaigns, :end_time
		add_column :campaigns, :time_left, :string
	end
end
