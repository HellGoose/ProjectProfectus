# User

FactoryGirl.define do
	factory :user do
		name 				'Jon'
		username 		'Snoe'
		email 			'nights@watch.com'
		provider 		'facebook'
		uid 				'123456'
		oauth_token '654321'
		oauth_token_expires_at Time.now + 1.week
		role        0
	end
end

FactoryGirl.define do
	factory :campaign do
		link 				'factorylink'
		user_id     '123'
	end
end

FactoryGirl.define do
	factory :round do
		duration 				5
		forceNewRound 	0
		decayRate 			0.75
		created_at			Time.now
		updated_at			Time.now
		currentRound		1
	end
end

FactoryGirl.define do
	factory :round_winner_user do
		user_id					1
		round_id				1
		roundWon				9
		created_at			Time.now
		updated_at			Time.now
	end
end

#   # This will use the User class (Admin would have been guessed)
#   factory :admin, class: User do
#     first_name "Admin"
#     last_name  "User"
#     admin      true
#   end
# end