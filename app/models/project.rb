class Project < ActiveRecord::Base
	#Required fields
	validates :title, :description, :content, presence: true

	#Relations
	has_many :iterations

	#Sets default values
	after_initialize :init
	def init
		print(self)
		self.flagged = false if (self.has_attribute? :flagged) && self.flagged.nil?
		self.voteCount ||= 0 if self.has_attribute? :voteCount
		self.finalVoteCount ||= 0 if self.has_attribute? :finalVoteCount
		self.isGettingFunded = false if (self.has_attribute? :isGettingFunded) && self.isGettingFunded.nil?
	end
end
