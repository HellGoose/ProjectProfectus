RSpec.configure do |config|
	for i in 0..9
		create(:campaign)
	end
	create(:round)
end