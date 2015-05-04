feature "Login" do
	scenario "with login button" do
		user = create(:user)
		for i in 0..9
			create(:campaign, user_id: user.id)
		end
		round = create(:round)
		login_with_oauth(user)
		expect(page).to have_text("Logout")
	end
end

feature "Logout" do
	before do
		user = create(:user)
		for i in 0..9
			create(:campaign, user_id: user.id)
		end
		round = create(:round)
		login_with_oauth(user)
	end
	scenario "with logout button" do
		visit '/signout'
		expect(page).to have_text("Login")
	end
end

feature 'create_user' do
	background do
		@user = create(:user)
		for i in 0..9
			create(:campaign, user_id: @user.id)
		end
		round = create(:round)
	end
	scenario "with facebook login" do
		login_with_oauth(@user)
		expect(page).to have_text(@user.name)
	end
end

feature "Edit user" do
	before do
		@user = create(:user, name: "AAARE")
		for i in 0..9
			create(:campaign, user_id: @user.id)
		end
		round = create(:round)
		login_with_oauth(@user)

	end
	scenario "with text", :js => true do
		click_on 'account'
		#visit '/users/' +@user.id.to_s# click_button 'account'
		
		#click_on 'edit'
		#visit edit_user_path(@user)
		#puts(page.body)
		#visit '/users/'+@user.id.to_s+'/edit'# click_button 'edit'
		
		#fill_in('user_username', :with => @user.name)
		#puts(find(:css, 'input#user_username.form-control').value)
		#within("div#wrap") do
			#within("div.container") do
			#	within("form#edit_user_"+@user.id.to_s+".edit_user") do
			#		within("form#edit_user_"+@user.id.to_s) do#form#edit_user_"+@user.id.to_s+".edit_user") do
						#fill_in 'input#user_username.form-control', :with => @user.name
						#fill_in 'user_email', :with => @user.email
			#		end
			#	end
			#end
		#end
		#puts(find('submit'))
		#click_on 'Update User'
		#puts(page.body)
		expect(page).to have_text("User was successfully updated.")
	end
end

feature "See profile" do
	before do
		@user = create(:user, name:"Karl")
		for i in 0..9
			create(:campaign, user_id: @user.id)
		end
		round = create(:round)
		login_with_oauth(@user)
	end
	scenario "by opening account page" do
		visit '/users/'+@user.id.to_s
		expect(page).to have_text("Profile")
	end
end