class Badge < ActiveRecord::Base
	#Relations (Used like: ClassName.relation):
	has_many :users
end