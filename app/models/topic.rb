class Topic < ActiveRecord::Base
	#Relations
	belongs_to :forum
	belongs_to :user
	has_many :posts
	has_and_belongs_to_many :user, join_table: "topic_votes"
end
