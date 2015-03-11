class Project < ActiveRecord::Base
	#Required fields
	validates :title, :description, :user_id, :content, :forum_id, :category_id, presence: true
	validates :description, length: { maximum: 150 }

	#Relations
	belongs_to :user
	belongs_to :forum, :dependent => :destroy
	belongs_to :category

	#Need to refund as well as delete donations.
	has_many :donations, class_name: 'ProjectDonation', :dependent => :delete_all
	has_many :votes, class_name: 'ProjectVote', :dependent => :delete_all
	has_many :usersVoted, class_name: 'User', through: 'ProjectVote'
	has_many :usersDonated, class_name: 'User', through: 'ProjectDonation'

	#Callbacks
	before_destroy :refund, prepend: true
	after_initialize :init

	private
		#Sets default values
		def init
			self.flagged = false if (self.has_attribute? :flagged) && self.flagged.nil?
			self.voteCount ||= 0 if self.has_attribute? :voteCount
			self.donationAmount ||= 0 if self.has_attribute? :donationAmount
		end

		#Refund all donations to the respective user
		def refund
			self.donations.each do |d|
				user = d.user
				user.money += d.amount
				user.save
			end
		end
end
