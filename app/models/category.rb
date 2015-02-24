class Category < ActiveRecord::Base
	#Relations
	has_many :projects
end
