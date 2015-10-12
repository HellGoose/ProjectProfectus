class CreateRoundWinnerUsers < ActiveRecord::Migration
  def change
    create_table :round_winner_users do |t|
    	t.integer :round
    	t.belongs_to :user
    	t.belongs_to :round
      t.timestamps null: false
    end
  end
end
