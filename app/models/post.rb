class Post < ActiveRecord::Base
	#Relations
	belongs_to :user
	belongs_to :topic
	has_and_belongs_to_many :comments, class_name: "Post", join_table: "post_comments"
	has_many :votes, class_name: "User", through: "post_votes"
end
