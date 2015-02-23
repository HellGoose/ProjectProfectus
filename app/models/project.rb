class Project < ActiveRecord::Base
	#Required fields
	validates :title, :description, :user_id, :content, presence: true

	#Relations
	belongs_to :user
	belongs_to :forum
	validates_associated :user
	#has_and_belongs_to_many :user, join_table: "project_reviews"
	#has_and_belongs_to_many :user, join_table: "project_votes"

	#Sets default values
	after_initialize :init
	def init
		self.flagged = false if (self.has_attribute? :flagged) && self.flagged.nil?
		self.voteCount ||= 0 if self.has_attribute? :voteCount
	end
end
