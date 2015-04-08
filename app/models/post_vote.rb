class PostVote < ActiveRecord::Base
	#Restrictions
	validates :user_id, :post_id, :isDownvote, presence: true
	
	#Relations
	belongs_to :user
	belongs_to :post
end
