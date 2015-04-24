t = Thread.new {
	runScript = false
	round = Round.find(1)
	i = 0
	while runScript do
		print "\nSeconds to next Round: " + (round.duration - i).to_s 
		if i >= round.duration or round.forceNewRound == true
			runRound(round.decayRate)
			round.forceNewRound = false
			round.save
			i = 0
		else
			i += 1
		end
		sleep 1
	end
}
at_exit{t.kill}

def runRound (decayRate)
	round = Round.find(1)
	campaigns = Campaign.all.order('roundScore DESC')
	users = User.all

	#Variables
	userOfTheRoundPoints = 437
	percentageOfRoundScore = 0.9

	#Declare Winners
	if campaigns.first.roundScore > 0
		winnerCampaigns = campaigns.first(3)
		winnerUser = winnerCampaigns.first.user

		#User of the round
		round.winnerUsers.create(user_id: winnerUser.id, round_id: round.id, roundWon: round.currentRound)
		winnerUser.points += userOfTheRoundPoints
		winnerUser.save

		#Top 3 campaigns
		i = 0
		winnerCampaigns.each do |c|
			round.winnerCampaigns.create(campaign_id: c.id, round_id: round.id, roundWon: round.currentRound, placing: i)
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

		#Increment to next round
		round.currentRound +=1
		round.save

		#Clear all votes
		CampaignVote.all.each do |cv|
			if cv.user.isOnStep == 0 or cv.user.isOnStep == 4
				cv.destroy
			end
		end
		#Reset user voting
		users.each do |u|
			if u.isOnStep == 4
				u.isOnStep = 0
				u.save
			end
		end
	end
end