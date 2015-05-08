class AddNextRoundTimeToRound < ActiveRecord::Migration
  def change
  	add_column :rounds, :roundEndTime, :integer
  end
end
