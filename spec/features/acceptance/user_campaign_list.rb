feature "User Campaign list" do
  before do
    user = create(:user)
    create(:campaign, title:"Campaign 1", link: 'https://www.kickstarter.com/projects/1078944858/lord-of-the-dead-an-asymmetrical-hex-and-counter-m?ref=category', 
      user_id: user.id)
  end
  scenario "by visiting user page", :js => true do
    visit '/users/'+User.first.id.to_s
    sleep 0.2
    save_screenshot('spec/features/screenshots/user_campaign_list.png')
    expect(page).to have_text('Campaign 1')
  end
end