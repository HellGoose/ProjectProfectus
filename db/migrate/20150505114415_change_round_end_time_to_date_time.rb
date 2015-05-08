class ChangeRoundEndTimeToDateTime < ActiveRecord::Migration
  def change
  	remove_column :rounds, :roundEndTime
  	add_column :rounds, :endTime, :datetime
  end
end
