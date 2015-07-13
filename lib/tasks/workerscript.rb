def databaseInit
	ActiveSupport.on_load(:after_initialize) do
		if Round.all.empty?
			initRound()
		end
		if Category.all.empty?
			initCategories()
		end
		if Badge.all.empty?
			initBadges()
		end
		if Campaign.all.empty?
			initCampaign()
		end
	end
end

def roundScript
	runScript = true
	ActiveSupport.on_load(:after_initialize) do
		puts ('Script started') if runScript == true
		round = Round.first
		round.forceNewRound = true
		while 1 do
			if Time.now.to_i >= round.endTime.to_i or round.forceNewRound == true
				puts ('Starting a new Round!')
				runNewRound(round.decayRate)
				round.endTime = Time.at(Time.now.to_i + round.duration).to_datetime
				round.forceNewRound = false
				round.save
			end
			sleep 1
			round = Round.first
		end
	end
end

private
def runNewRound (decayRate)
	if Campaign.all.empty?
		puts "Failed to start round! There are no campaigns in the database."
		return
	end
	round = Round.first
	campaigns = Campaign.all.order('roundScore DESC')
	users = User.all

	#Variables
	usersOfTheRoundPoints = [25, 10, 5]
	percentageOfRoundScore = 0.9

	#Declare Winners
	if campaigns.first.roundScore > 0
		winnerCampaigns = campaigns.first(3)
		winnerUsers = []
		winnerCampaigns.each do |wc|
			winnerUsers << wc.user
		end

		#User of the round
		round.winnerUsers.create(
			user_id: winnerUsers[0].id,
			round_id: round.id,
			roundWon: round.currentRound
		)
		i = 0
		winnerUsers.each do |wu|
			wu.points += usersOfTheRoundPoints[i]
			wu.save
			i+=1
		end

		#Top 3 campaigns
		i = 0
		winnerCampaigns.each do |c|
			round.winnerCampaigns.create(
				campaign_id: c.id,
				round_id: round.id,
				roundWon: round.currentRound,
				placing: i
			)
			i+=1
		end

		#Compute and reset scores
		campaigns.each do |c|
			c.globalScore = (c.globalScore * decayRate + c.roundScore).to_i
			c.user.points += (c.roundScore*percentageOfRoundScore).to_i
			c.user.save
			c.roundScore = 0
			c.save
		end

		#Clear all votes and add scores

		CampaignVote.all.each do |cv|
			if cv.user.isOnStep == 0 or cv.user.isOnStep == 4
				case cv.campaign.id
				when winnerCampaigns[0].id, winnerCampaigns[1].id, winnerCampaigns[2].id
					placing = RoundWinnerCampaign.find_by(roundWon: round.currentRound, campaign_id: cv.campaign_id).placing
					cv.user.points += (usersOfTheRoundPoints[placing]/5).to_i
					cv.user.save
				end
				cv.destroy
			end
		end

		#Reset user voting
		users.each do |u|
			if u.isOnStep == 4
				u.isOnStep = 0
				u.hasLoggedInThisRound = false
				u.save
			end
		end

		#Increment to next round
		round.currentRound += 1
		round.save
		puts "Done! New Round Started."
	else
		puts "Failed to start round! No scores found. Continuing with this round."
	end
end

private
	def initRound
		Round.create(
			duration: 3600, 
			decayRate: 0.75)
	end

	def initCategories
		Category.create(name: 'Technology')
	end

	def initCampaign
		Campaign.create(
			name: "TestCampaign",
		)
	end

	def initBadges
		Badge.create(
			name: 'My First Campaign', 
			description: 'Created a campaign.', 
			imageUrl: 'http://badgemonkey.com/images/im-just-a-freaking.jpg', 
			points: 500)
		Badge.create(
			name: 'Campaign Fronter', 
			description: 'Created 10 campaigns.', 
			imageUrl: 'http://badgemonkey.com/images/iamawesombadge.jpg', 
			points: 500)
	end