feature "Discussion board on campaigns" do
  before do
    @user = create(:user)
    login_with_oauth(@user)
  end
  scenario "by clicking a campaign", :js => true do
    click_on 'Add Campaign'
    fill_in 'campaign_link', :with => 'https://www.kickstarter.com/projects/level99games/millennium-blades-the-ccg-simulator-board-game?ref=category'
    enable_element_by_id('submitButton')
    click_on 'submitButton'
    visit '/campaigns/'+Campaign.first.id.to_s
    sleep 0.2
    save_screenshot('spec/features/screenshots/discussion_board_on_campaigns.png')
    expect(page).to have_button('Create Post')
  end
end