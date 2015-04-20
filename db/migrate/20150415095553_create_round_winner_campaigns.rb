class CreateRoundWinnerCampaigns < ActiveRecord::Migration
  def change
    create_table :round_winner_campaigns do |t|
    	t.integer :round
    	t.integer :placing
    	t.belongs_to :campaign
    	t.belongs_to :round
      t.timestamps null: false
    end
    add_column :rounds, :currentRound, :integer
  end
end
