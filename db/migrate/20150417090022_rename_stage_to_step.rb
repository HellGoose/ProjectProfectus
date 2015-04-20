class RenameStageToStep < ActiveRecord::Migration
  def change
  	rename_column :campaign_votes, :stage, :step
  end
end
