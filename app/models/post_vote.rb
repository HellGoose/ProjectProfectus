class PostVote < ActiveRecord::Base
	#Restrictions
	validates :user_id, :project_id, presence: true
	
	belongs_to :user
	belongs_to :post
end
