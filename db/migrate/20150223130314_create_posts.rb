class CreatePosts < ActiveRecord::Migration
	def change
		create_table :posts do |t|
			t.text :content
			t.datetime :date
			t.integer :upvotes
			t.integer :downvotes
			t.belongs_to :topic, index: true
			t.belongs_to :user, index: true

			t.timestamps null: false
		end
		create_join_table :post, :post, table_name: :post_comments
		create_join_table :post, :user, table_name: :post_votes
	end
end
