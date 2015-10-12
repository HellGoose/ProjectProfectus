class AddNumberOfVotersLastRoundToRound < ActiveRecord::Migration
  def change
  	add_column :rounds, :numberOfVotersLastRound, :integer
  	Round.update_all(numberOfVotersLastRound: 0)
  end
end
