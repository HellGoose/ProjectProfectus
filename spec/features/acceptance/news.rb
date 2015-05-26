 feature "News" do
	scenario "section on front page", :js => true do
		visit root_path
		#page.execute_script "window.scrollBy(0, 1000)" # For scrolling down to news before taking screenshot. Does not work.
		save_screenshot('spec/features/screenshots/news.png')
		expect(page).to have_text("News")
	end
end