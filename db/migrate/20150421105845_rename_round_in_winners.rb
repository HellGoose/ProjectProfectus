class RenameRoundInWinners < ActiveRecord::Migration
  def change
  	rename_column :round_winner_users, :round, :roundWon
  	rename_column :round_winner_campaigns, :round, :roundWon
  end
end
