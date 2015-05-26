feature "Winner" do
  before do
    user = create(:user, name: "Winner 1")
    round = create(:round)
    create(:round_winner_user, user_id: user.id, round_id: round.id)
  end
  scenario "by seeing 'Champion' shown on the start page", :js => true do
    visit root_path
    sleep 0.2
    save_screenshot('spec/features/screenshots/winners.png')
    expect(page).to have_text('Champion')
  end
end