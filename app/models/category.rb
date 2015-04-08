class Category < ActiveRecord::Base
	#Relations
	has_many :campaigns
end