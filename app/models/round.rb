class Round < ActiveRecord::Base
	#Relations (Used like: ClassName.relation):
	has_many :winnerUsers, class_name: "RoundWinnerUser"
	has_many :winnerCampaigns, class_name: "RoundWinnerCampaign"

	after_initialize :init

	private
		#Sets default values
		def init
			self.duration ||= 3600 if self.has_attribute? :duration
			self.forceNewRound ||= false if self.has_attribute? :forceNewRound
			self.decayRate ||= 0.75 if self.has_attribute? :decayRate
			self.currentRound ||= 0 if self.has_attribute? :currentRound
			self.endTime ||= Time.at(Time.now.to_i + self.duration).to_datetime if self.has_attribute? :endTime
		end
end
