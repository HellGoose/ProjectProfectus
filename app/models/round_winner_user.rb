class RoundWinnerUser < ActiveRecord::Base
	#Relations (Used like: ClassName.relation):
	belongs_to :user
	belongs_to :round
end
