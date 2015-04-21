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

#   # This will use the User class (Admin would have been guessed)
#   factory :admin, class: User do
#     first_name "Admin"
#     last_name  "User"
#     admin      true
#   end
# end