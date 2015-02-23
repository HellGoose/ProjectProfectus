class Post < ActiveRecord::Base
	#Relations
	belongs_to :user
	belongs_to :topic
	has_and_belongs_to_many :post, join_table: "post_comments"
	has_and_belongs_to_many :user, join_table: "post_votes"
end
