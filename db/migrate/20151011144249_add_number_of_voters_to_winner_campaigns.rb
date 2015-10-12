class AddNumberOfVotersToWinnerCampaigns < ActiveRecord::Migration
  def change
  	change_table :round_winner_campaigns do |t|
  		t.integer :numberOfVoters
  		t.integer :score
  	end
  	RoundWinnerCampaign.update_all(numberOfVoters: 0, score: 0)
  end
end
