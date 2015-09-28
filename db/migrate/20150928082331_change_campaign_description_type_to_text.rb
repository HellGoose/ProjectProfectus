class ChangeCampaignDescriptionTypeToText < ActiveRecord::Migration
  def up
    change_column :campaigns, :description, :text
  end

  def down
    change_column :campaigns, :description, :string
  end
end
