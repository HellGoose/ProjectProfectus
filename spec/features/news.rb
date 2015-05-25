 feature "News" do
	scenario "section on front page", :js => true do
		visit root_path
		save_screenshot('spec/features/screenshots/news.png')
		expect(page).to have_text("News")
	end
end