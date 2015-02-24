class CreatePostVotes < ActiveRecord::Migration
	def change
		drop_table :post_votes
		create_table :post_votes do |t|
			t.belongs_to :user, index: true
			t.belongs_to :post, index: true
			t.boolean :isDownvote
			t.timestamps null: false
		end
	end
end
