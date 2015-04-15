Thread.new {
	round = Round.find(1)
	i = 0

	while true  do
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
	campaigns = Campaigns.order('roundScore DESC')
	users = User.all

	users.each do |u|
		u.isOnStep = 0
		u.save
	end

	campaigns.each do |c|
		c.globalScore = c.globalScore * decayRate + c.roundScore
		c.roundScore = 0
		c.save
	end
end