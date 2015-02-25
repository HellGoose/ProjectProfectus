class Post < ActiveRecord::Base
	#Restrictions
	validates :content, :user_id, :topic_id, presence: true

	#Relations
	belongs_to :user
	belongs_to :topic
	has_and_belongs_to_many :comments, class_name: "Post", join_table: "post_comments"
	has_many :votes, class_name: "User", through: "post_votes"

	#Sets default values
	after_initialize :init
	def init
		self.upvotes ||= 0 if self.has_attribute? :upVotes
		self.downvotes ||= 0 if self.has_attribute? :downVotes
	end
end
