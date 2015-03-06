class TopicVote < ActiveRecord::Base
	#Restrictions
	validates :user_id, :topic_id, presence: true
	
	#Relations
	belongs_to :user
	belongs_to :topic
end
