feature "Login" do
	scenario "with login button" do
		@user = create(:user)
		login_with_oauth(@user)
		expect(page).to have_text("Logout")
	end
end

feature "Logout" do
	before do
		@user = create(:user)
		login_with_oauth(@user)
	end
	scenario "with logout button" do
		click_on @user.name
		click_on 'Logout'
		expect(page).to have_text("Login")
	end
end

feature 'Create new user' do
	background do
		@user = build(:user, name:'Karl')
	end
	scenario "with facebook login" do
		login_with_oauth(@user)
		expect(page).to have_text(@user.name)
	end
end

feature "See profile" do
	before do
		@user = create(:user)
		login_with_oauth(@user)
	end
	scenario "by opening account page" do
		click_on @user.name
		click_on 'account'
		expect(page).to have_text("Profile")
	end
end

feature "Edit profile" do
	before do
		@user = build(:user)
		login_with_oauth(@user)
	end
	scenario "with text", :js => true do
		click_on @user.name
		click_on 'account'
		click_on 'edit'
		fill_in 'user_username', :with => @user.name
		fill_in 'user_email', :with => @user.email
		click_on 'Update User'
		expect(page).to have_text("User was successfully updated.")
	end
end