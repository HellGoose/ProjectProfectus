class Project < ActiveRecord::Base
	validates :title, :description, :content, presence: true
	after_initialize :init


	def init
		self.flagged ||= false
		self.voteCount ||= 0
		self.finalVoteCount ||= 0
		self.isGettingFunded ||= false
	end
end
