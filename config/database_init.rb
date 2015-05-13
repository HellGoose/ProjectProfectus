def databaseInit
	t = Thread.new {
		until defined?(ActiveRecord::Base)
			sleep 0.1
		end
		sleep 2
		if Round.all.empty?
			initRound()
		end
		if Category.all.empty?
			initCategories()
		end
		if Badge.all.empty?
			initBadges()
		end
	}
	at_exit{t.kill}
	t.abort_on_exception = true
end

private
	def initRound
		Round.create(
			duration: 3600, 
			decayRate: 0.75)
	end

	def initCategories
		Category.create(name: 'Show All')
	end

	def initBadges
		Badge.create(
			name: 'My First Campaign', 
			description: 'Created a campaign.', 
			imageUrl: 'http://badgemonkey.com/images/im-just-a-freaking.jpg', 
			points: 500)
	end