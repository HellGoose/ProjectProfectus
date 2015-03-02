class ProjectVote < ActiveRecord::Base
	#Restrictions
	validates :user_id, :project_id, presence: true

	#Relations
	belongs_to :user
	belongs_to :project
end
