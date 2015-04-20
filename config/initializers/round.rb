Thread.new {
	round = Round.find(1)
	i = 0
	print "Round: " + round.currentRound.to_s + "\n"
	print "Duration: " + round.duration.to_s + "\n"
	print "DecayRate: " + round.decayRate.to_s + "\n"
	while true  do
		print "\nloop: " + i.to_s 
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

def runRound (decayRate)
	campaigns = Campaign.all.order('roundScore DESC')
	users = User.all

	#Declare Winners
	if campaigns.first.roundScore > 0
		winnerCampaigns = campaigns.first(3)
		winnerUser = winnerCampaigns.first.user

		#User of the round
		round.winnerUser.create(user_id: winnerUser.id, round_id: round.id, round: round.currentRound)

		#Top 3 campaigns
		i = 0
		winnerCampaigns.each do |c|
			round.winnerCampaigns.create(campaign_id: c.id, round_id: round.id, round: round.currentRound, placing: i)
			i+=1
		end

		#Increment to next round
		round.currentRound +=1
		round.save
	end

	#Reset user voting
	users.each do |u|
		u.isOnStep = 0
		u.campaignVotes.clear
		u.save
	end

	#Compute and reset scores
	campaigns.each do |c|
		c.globalScore = c.globalScore * decayRate + c.roundScore
		c.roundScore = 0
		c.save
	end
end