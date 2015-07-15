class AddSupportForLimitedAdditions < ActiveRecord::Migration
  def change
  	add_column :users, :additionsThisRound, :integer
  	add_column :rounds, :maxAdditionsPerUser, :integer
  end
end
