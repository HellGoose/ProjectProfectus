class Topic < ActiveRecord::Base
	#Restrictions
	validates :title, :forum_id, :user_id, presence: true

	#Relations
	belongs_to :forum
	belongs_to :user
	has_many :posts, :dependent => :destroy
	has_many :votes, class_name: "TopicVote", :dependent => :delete_all
	has_many :usersVoted, class_name: "User", through: "topic_votes"

	#Sets default values
	after_initialize :init
	def init
		self.postCount ||= 0 if self.has_attribute? :postCount
		self.upvotes ||= 0 if self.has_attribute? :upVotes
		self.downvotes ||= 0 if self.has_attribute? :downVotes
	end
end
