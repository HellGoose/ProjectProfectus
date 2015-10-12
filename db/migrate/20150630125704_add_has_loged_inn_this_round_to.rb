class AddHasLogedInnThisRoundTo < ActiveRecord::Migration
  def change
  	add_column :users, :hasLoggedInThisRound, :boolean
  end
end
