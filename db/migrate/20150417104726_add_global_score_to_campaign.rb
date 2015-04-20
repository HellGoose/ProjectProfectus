class AddGlobalScoreToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :globalScore, :integer
  end
end
