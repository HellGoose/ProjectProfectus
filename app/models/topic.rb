class Topic < ActiveRecord::Base
	#Relations
	belongs_to :forum
	belongs_to :user
	has_many :posts
	has_many :votes, class_name: "User", through: "topic_votes"
end
