class ProjectVote < ActiveRecord::Base
	#Relations
	belongs_to :user
	belongs_to :project
end
