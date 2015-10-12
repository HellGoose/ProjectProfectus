class PostVote < ActiveRecord::Base
	#Restrictions
	validates :user_id, :post_id, presence: true
	
	#Relations (Used like: ClassName.relation):
	belongs_to :user
	belongs_to :post
end