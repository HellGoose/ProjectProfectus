class AddStatDumpTable < ActiveRecord::Migration
  def change
  	create_table :stat_dumps do |t|
      t.integer		:roundNumber
      t.text			:details
      t.integer   :numberOfNominations
      t.integer		:numberOfNominationsSeen
      t.integer		:numberOfVotes
      t.integer		:numberOfFinalVotes

      t.timestamps null: false
    end
  end
end
