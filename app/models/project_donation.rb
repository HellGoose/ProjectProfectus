class ProjectDonation < ActiveRecord::Base
	#Relations
	belongs_to :User
	belongs_to :project
end
