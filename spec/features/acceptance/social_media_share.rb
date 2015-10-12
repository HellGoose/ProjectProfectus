feature "Social media share button" do
  before do
    user = create(:user)
    create(:campaign, title:"Campaign 1", link: 'https://www.kickstarter.com/projects/1078944858/lord-of-the-dead-an-asymmetrical-hex-and-counter-m?ref=category', 
      user_id: user.id)
  end
  scenario "is present at campaign details", :js => true do
    visit '/campaigns/'+Campaign.first.id.to_s
    sleep 0.2
    save_screenshot('spec/features/screenshots/social_media_share.png')
    expect(page).to have_css('div.social-share-button')
  end
end