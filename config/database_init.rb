def databaseInit
	s = Thread.new {
		until defined?(ActiveSupport)
			sleep 0.1
		end
		ActiveSupport.on_load(:after_initialize) do
			t = Thread.new {
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
	}
	at_exit{s.kill}
	s.abort_on_exception = true
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