class ReportedCampaign < ActiveRecord::Base
	#Restrictions
	validates :user_id, :campaign_id, presence: true

	#Relations (Used like: ClassName.relation):
	belongs_to :user
	belongs_to :campaign

	#Callbacks
	after_initialize :init

	private
	#Sets default values
	def init
		self.round ||= -1 if self.has_attribute? :round
		self.nominated = false if self.has_attribute? :nominated && self.nominated.nil?
	end
end
