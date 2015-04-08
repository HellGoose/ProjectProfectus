class Post < ActiveRecord::Base
	#Restrictions
	validates :content, :user_id, :campaign_id, presence: true

	#Relations
	belongs_to :user
	belongs_to :campaign
	has_and_belongs_to_many :comments, 
		class_name: "Post", 
		join_table: "post_comments", 
		foreign_key: "post_id",
		association_foreign_key: "comment_id", 
		:dependent => :destroy
	has_many :votes, class_name: "PostVote", :dependent => :delete_all
	has_many :usersVoted, class_name: "User", through: "post_votes"

	#Callbacks
	after_initialize :init
	before_destroy :destroyComments

	private
		#Sets default values
		def init
			self.voteCount ||= 0 if self.has_attribute? :voteCount
			self.isComment = false if (self.has_attribute? :isComment) && self.isComment.nil?
		end

		#Delete all comments before deleting Post
		def destroyComments
			self.comments.each do |c|
				if !c.destroy
					c.delete
				end
			end
		end
end