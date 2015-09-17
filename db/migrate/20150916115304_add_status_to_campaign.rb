class AddStatusToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :status, :string
    Campaign.update_all(status: "ready")
  end
end
