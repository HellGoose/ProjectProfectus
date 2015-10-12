 feature "User login" do
	scenario "with login button", :js => true do
		@user = create(:user, name:"sam")
		login_with_oauth(@user)
		save_screenshot('spec/features/screenshots/user_login.png')
		expect(page).to have_text("sam")
	end
end