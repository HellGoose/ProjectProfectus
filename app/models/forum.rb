class Forum < ActiveRecord::Base
	#Relations
	has_one :project
	has_many :topics

	#Sets default values
	after_initialize :init
	def init
		self.topicCount ||= 0 if self.has_attribute? :topicCount
		self.postCount ||= 0 if self.has_attribute? :postCount
	end
end
