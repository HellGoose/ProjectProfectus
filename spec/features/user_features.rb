feature "Login" do
	scenario "with login button" do
		@user = create(:user, name: "Kari")
		@campaign = create(:campaign, user_id: @user.id)
		login_with_oauth(@user)
		expect(page).to have_text("Logout")
	end
end

feature "Logout" do
	before do
		@user = create(:user, name: "kari")
		@campaign = create(:campaign, user_id: @user.id)
		login_with_oauth(@user)
	end
	scenario "with logout button" do
		visit '/signout'
		expect(page).to have_text("Login")
	end
end 

feature 'create_user' do
  background do
    @user = build(:user)
    @campaign = create(:campaign, user_id: @user.id)
  end
  scenario "with facebook login" do
    login_with_oauth(@user)
    expect(page).to have_text(@user.name)
  end
end

feature "Edit user" do
  before do
    @user = create(:user, name: "Karl")
    @campaign = create(:campaign, user_id: @user.id)
    #puts(campaign.id, user.id)
    login_with_oauth(@user)
  end
  scenario "with text" do
  	visit '/users/' + @user.id.to_s# click_button 'account'
  	visit '/users/'+@user.id.to_s+'/edit'# click_button 'edit'
    fill_in('user_username', :with => @user.name)
    #within("div#form-group") do
      #fill_in 'user_username', :with => @user.name
      #fill_in 'user_email', :with => @user.email
    #end
    click_button 'update_user'
    expect(page).to have_text("User was successfully updated.")
  end
end
=begin
feature "See profile" do
	before do
		@user = build(:user, name: "Karl")
		@campaign = create(:campaign, user_id: @user.id)
		login_with_oauth(user)
	end
	scenario "by opening account page" do
		visit '/users/:user'
		expect(page).to have_text("Karl")
	end
end
=end