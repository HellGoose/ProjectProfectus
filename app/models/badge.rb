class Badge < ActiveRecord::Base
	#Relations
	has_many :users
end