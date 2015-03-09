class News < ActiveRecord::Base
	#Restrictions
	validates :content, :title, presence: true

end
