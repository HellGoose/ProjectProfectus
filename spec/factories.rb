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
		points			0
		level				0
	end
end

FactoryGirl.define do
	factory :campaign do
		title						'kickstarter'
		link 						'https://www.kickstarter.com/'
		user_id     		1
		category_id			nil
		created_at			Time.now
		updated_at			Time.now
		globalScore			0
		roundScore			0
	end
end

FactoryGirl.define do
	factory :category do
		name						"test_category"
		created_at			Time.now
		updated_at			Time.now
	end
end

FactoryGirl.define do
	factory :campaign_votes do
		user_id					nil
		campaign_id 		nil
		created_at			Time.now
		updated_at			Time.now
		step						0
		voteType				nil
	end
end

FactoryGirl.define do
	factory :round do
		duration 				86400
		forceNewRound 	0
		decayRate 			0.9
		created_at			Time.now
		updated_at			Time.now
		currentRound		1
	end
end

FactoryGirl.define do
	factory :round_winner_user do
		roundWon				1
		round_id				1
		user_id					1
		created_at			Time.now
		updated_at			Time.now
	end
end

FactoryGirl.define do
	factory :round_winner_campaign do
		roundWon				1
		placing					nil
		campaign_id			1
		round_id				1
		created_at			Time.now
		updated_at			Time.now
	end
end