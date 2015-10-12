class WebsiteLog < ActiveRecord::Base
	#Restrictions
	validates :website, presence: true
	validates_uniqueness_of :website

	#Callbacks
	after_initialize :init

	private
	#Sets default values
	def init
		self.tried ||= 1 if self.has_attribute? :tried
	end
end
