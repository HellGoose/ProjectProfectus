class PointsHistory < ActiveRecord::Base
	#Restrictions:
	validates :points_received, presence: true

	#Relations (Used like: ClassName.relation):
	belongs_to :user

	#Callbacks
	after_initialize :init

private
	#Set default values
	def init
		self.points_received ||= 0 if self.has_attribute? :points_received
		self.description ||= "Unknown" if self.has_attribute? :description
		self.seen ||= false if self.has_attribute? :seen
	end
end
