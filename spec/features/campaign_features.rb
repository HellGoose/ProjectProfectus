feature "Add project" do
  background do
    user = create(:user)
    login_with_oauth(user)
  end
  scenario "Create new campaign" do
    visit '/campaigns/new'
    within("#campaign") do
      fill_in 'campaign_link', :with => 'google.com'
    end
    click_button 'Create Campaign'
    expect(page).to have_text("campaign was successfully created.")
  end
end