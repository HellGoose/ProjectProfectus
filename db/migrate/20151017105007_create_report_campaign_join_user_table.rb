class CreateReportCampaignJoinUserTable < ActiveRecord::Migration
  def change
    create_table :reported_campaigns do |t|
      t.belongs_to :campaign, index: true
      t.belongs_to :user, index: true
      t.integer :round
      t.boolean :nominated
    end
    add_column :campaigns, :reported, :integer
  end
end
