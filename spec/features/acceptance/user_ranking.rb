feature "User ranking" do
  before do
    user = create(:user, level: 2)
    create(:campaign, title:"Campaign 1", link: 'https://www.kickstarter.com/projects/1078944858/lord-of-the-dead-an-asymmetrical-hex-and-counter-m?ref=category', 
      user_id: user.id)
  end
  scenario "is visible on user page", :js => true do
    visit '/users/'+User.first.id.to_s
    sleep 0.2
    save_screenshot('spec/features/screenshots/user_ranking.png')
    expect(page).to have_text('Level: 2')
  end
end