def roundScript
	runScript = true
	t = Thread.new {
		puts ('Starting script!') if runScript == true
		until defined?(ActiveRecord::Base)
			sleep 0.1
		end
		sleep 5
		round = Round.first
		puts ('Script started') if runScript == true
		while runScript do
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
	}
	at_exit{t.kill}
	t.abort_on_exception = true
end

private
def runNewRound (decayRate)
	if Campaign.all.empty?
		return
	end
	round = Round.first
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