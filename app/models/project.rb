class Project < ActiveRecord::Base
	#Required fields
	validates :title, :description, :user_id, :content, presence: true

	#Relations
	has_many :iterations
	belongs_to :user
	validates_associated :user

	#Sets default values
	after_initialize :init
	def init
		self.flagged = false if (self.has_attribute? :flagged) && self.flagged.nil?
		self.voteCount ||= 0 if self.has_attribute? :voteCount
		self.finalVoteCount ||= 0 if self.has_attribute? :finalVoteCount
		self.isGettingFunded = false if (self.has_attribute? :isGettingFunded) && self.isGettingFunded.nil?
	end
end
