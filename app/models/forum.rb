class Forum < ActiveRecord::Base
	#Relations
	has_one :project
	has_many :topics
end
