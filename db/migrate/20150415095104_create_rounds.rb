class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
    	t.integer :duration
    	t.boolean :forceNewRound
    	t.float :decayRate
      t.timestamps null: false
    end
    add_column :users, :isOnStep, :integer
    add_column :campaigns, :roundScore, :integer
  end
end
