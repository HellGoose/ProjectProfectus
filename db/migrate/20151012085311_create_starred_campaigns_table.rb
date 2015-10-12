class CreateStarredCampaignsTable < ActiveRecord::Migration
  def change
    create_table :stared_campaigns do |t|
    	t.belongs_to :campaign, index: true
    	t.belongs_to :user, index: true
    	t.integer :round
    end
  end
end
