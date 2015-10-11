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
		if Crowdfunding_site.all.empty?
			initCrowdfunding_sites()
		end
	end
end

def roundScript
	runScript = true
	ActiveSupport.on_load(:after_initialize) do
		puts ('Script started') if runScript == true
		round = Round.first
		round.forceNewRound = false
		while 1 do
			if Time.now.to_i >= round.endTime.to_i or round.forceNewRound == true
				puts ('Starting a new Round!')
				runNewRound(round.decayRate)
				if Time.now.to_i >= round.endTime.to_i
					puts "Extending the current round."
					round.endTime = Time.at(round.endTime.to_i + round.duration).to_datetime
				end
				round.forceNewRound = false
				round.save
				#cleanupDatabase
			end
			sleep 1
			round = Round.first
		end
	end
end

private
def runNewRound (decayRate)
	if Campaign.where(nominated: true).count <= 30
		puts "Failed to start new round! Not enough nominated campaigns for the next round."
		return
	end
	round = Round.first
	campaigns = Campaign.where(votable: true).order('roundScore DESC')
	users = User.all.order('points DESC')

	#Variables
	usersOfTheRoundPoints = [25, 10, 5]
	percentageOfRoundScore = 0.1

	
	statDump = StatDump.new
	statDump.roundNumber = round.currentRound
	statDump.numberOfNominations = Campaign.count(votable: true)
	statDump.numberOfNominationsSeen = Campaign.where.not(timesShownInVoting: 0).count
	statDump.numberOfVotes = CampaignVote.where.not(voteType: 0).count
	statDump.numberOfFinalVotes = CampaignVote.where(voteType: 2).count
	details = "<b>Round:</b> #{round.currentRound}</br><b>Date:</b> #{Time.now}"

	#Declare Winners
	if !campaigns.first.nil? && campaigns.first.roundScore > 0
		winnerCampaigns = campaigns.first(3)
		winnerUsers = []
		winnerCampaigns.each do |wc|
			winnerUsers << wc.nominator
		end
	

		#User of the round
		round.winnerUsers.create(
			user_id: winnerUsers[0].id,
			round_id: round.id,
			roundWon: round.currentRound
		)
		i = 0
		details += "</br><b>WinnerUsers:</b> "
		winnerUsers.each do |wu|
			details += "#{wu.name}, "
			notification = PointsHistory.new(description: 'A nominee of yours have won the round!', points_received: usersOfTheRoundPoints[i])
			wu.pointsHistories << notification
			wu.points += usersOfTheRoundPoints[i]
			wu.save
			i+=1
		end
		details.slice!(-2,2)

		#Top 3 campaigns
		i = 0
		winnerCampaigns.each do |c|
			round.winnerCampaigns.create(
				campaign_id: c.id,
				round_id: round.id,
				roundWon: round.currentRound,
				placing: i
				numberOfVoters: CampaignVote.where.not(voteType: 0).where(campaign_id: c.id).count
				score: c.roundScore
			)
			i+=1
		end

		#Compute and reset scores
		details += "</br><b>Campaigns:</b></br><table class=\"table table-condensed table-responsive\">"
		details += "<thead><tr><th>Title</th><th>Score</th><th>Seen</th></tr></thead><tbody>"
		campaigns.each do |c|
			c.globalScore = (c.globalScore * decayRate + c.roundScore).to_i
			details += "<tr><td>#{c.title}</td><td>#{c.roundScore}</td><td>#{c.timesShownInVoting}</td></tr>"
			if (c.roundScore*percentageOfRoundScore).to_i > 0
				notification = PointsHistory.new(description: 'Your nominee received ' + c.roundScore.to_s + ' round points!', points_received: (c.roundScore*percentageOfRoundScore).to_i)
				c.user.pointsHistories << notification
				c.user.points += (c.roundScore*percentageOfRoundScore).to_i
				c.user.save
				if c.user_id != c.nominator_id
					c.nominator.pointsHistories << notification
					c.nominator.points += (c.roundScore*percentageOfRoundScore).to_i
					c.nominator.save
				end
			end
			c.roundScore = 0
			c.save
		end
		details += "</tbody></table>"

		#Clear all votes and add scores
		CampaignVote.all.each do |cv|
			if cv.user.isOnStep == 0 or cv.user.isOnStep == 4
				case cv.campaign.id
				when winnerCampaigns[0].id, winnerCampaigns[1].id, winnerCampaigns[2].id
					placing = RoundWinnerCampaign.find_by(roundWon: round.currentRound, campaign_id: cv.campaign_id).placing
					notification = PointsHistory.new(description: 'A nominee you voted for won the round!', points_received: (usersOfTheRoundPoints[placing]/5).to_i)
					cv.user.pointsHistories << notification
					cv.user.points += (usersOfTheRoundPoints[placing]/5).to_i
					cv.user.save
				end
			end
		end
	end

	#Reset user voting
	details += "</br><b>Users:</b></br><table class=\"table table-condensed table-responsive\">"
	details += "<thead><tr><th>Name</th><th>Score</th><th>Nominations</th></tr></thead><tbody>"
	users.each do |u|
		details += "<tr><td>#{u.name}</td><td>#{u.points}</td><td>#{u.additionsThisRound}</td></tr>"
		u.isOnStep = 0
		u.hasLoggedInThisRound = false
		u.additionsThisRound = 0
		u.save
	end
	details += "</tbody></table>"

	#Increment to next round
	round.currentRound += 1
	round.numberOfVotersLastRound = CampaignVote.where(voteType: 2).select(:user_id).count
	round.save
	Campaign.update_all(timesShownInVoting: 0, votable: false)
	Campaign.where(nominated: true).update_all(nominated: false, votable: true)
	CampaignVote.destroy_all
	statDump.details = details
	if statDump.save
		puts "Stats dumped!"
	end
	puts "Done! New Round Started."
end

def cleanupDatabase
	PointsHistory.all.each do |ph|
		if ph.seen
			ph.destroy
		end
	end
end

def initRound
	Round.create(
		duration: 3600, 
		decayRate: 0.75,
		maxAdditionsPerUser: 3,
		numberOfVotersLastRound: 0)
end

def initCategories
	Category.create(name: 'Technology')
end

def initBadges
	Badge.create(
		name: 'My First Campaign', 
		description: 'Created a campaign.', 
		imageUrl: 'http://badgemonkey.com/images/im-just-a-freaking.jpg', 
		points: 50)
	Badge.create(
		name: 'Campaign Fronter', 
		description: 'Created 10 campaigns.', 
		imageUrl: 'http://badgemonkey.com/images/iamawesombadge.jpg', 
		points: 50)
end

def initCrowdfunding_sites
	Crowdfunding_site.create(
		name: 'Kickstarter',
		logo: 'https://www.kickstarter.com/download/kickstarter-logo-k-color.png',
		link: 'https://www.kickstarter.com',
		domain: 'www.kickstarter.com')
	Crowdfunding_site.create(
		name: 'Indiegogo',
		logo: 'https://g1.iggcdn.com/assets/site/brand/IGG_Logo_Frame_GOgenta_RGB-2-f8565fa188a9dd16fb6c67321150b94e.png',
		link: 'https://www.indiegogo.com',
		domain: 'www.indiegogo.com')
end
