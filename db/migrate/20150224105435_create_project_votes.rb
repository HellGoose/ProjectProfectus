class CreateProjectVotes < ActiveRecord::Migration
  def change
    drop_table :project_votes
	create_table :project_votes do |t|
		t.belongs_to :user, index: true
		t.belongs_to :project, index: true
		t.boolean :isDownvote
		t.timestamps null: false
	end
  end
end
