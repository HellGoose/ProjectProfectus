require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'

module Medusa
	include Capybara::DSL

	Capybara.configure do |config|
		config.javascript_driver = :poltergeist
		config.run_server = false
		config.current_driver = :poltergeist
	end

	def new_session
		Capybara.register_driver :poltergeist do |app|
			Capybara::Poltergeist::Driver.new(app, {js_errors: false})
		end

		# Start up a new thread
    session = Capybara::Session.new(:poltergeist)

    # Report using a particular user agent
    session.driver.headers = { 'User-Agent' =>
      "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.81 Safari/537.36" }

    # Return the driver's session
    return session
	end

	def get_html(session, url)
		session.visit(url)
		sleep 5
		File.open('debug.html', 'w') {|f| f.write(session.html) }
		return session.html
		#page.body
	 end
end
