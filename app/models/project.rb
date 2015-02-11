class Project < ActiveRecord::Base
	#Required fields:
	validates :title, presence: true
end
