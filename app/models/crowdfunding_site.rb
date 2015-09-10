class Crowdfunding_site < ActiveRecord::Base
	#Relations (Used like: ClassName.relation):
	has_many :campaigns
end