class Project < ActiveRecord::Base
	#Required fields
	validates :title, :description, :user_id, :content, presence: true
	validates :description, length: { maximum: 150 }

	#Relations
	belongs_to :user
	belongs_to :forum
	has_many :votes, class_name: "User", through: "project_votes"

	#Sets default values
	after_initialize :init
	def init
		self.flagged = false if (self.has_attribute? :flagged) && self.flagged.nil?
		self.voteCount ||= 0 if self.has_attribute? :voteCount
	end
end
