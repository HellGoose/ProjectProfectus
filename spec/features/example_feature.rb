# Specify user stories here in scenarios
=begin
feature "Signing in" do
  background do
    valid_facebook_login_setup
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end

  scenario "Signing in" do
    visit '/auth/facebook/callback' # generic user login/create
    within("#session") do
      fill_in 'Email', :with => 'user@example.com'
    end
    click_button 'Sign in'
    expect(page).to have_content 'Success'
  end

  given(:other_user) { User.make(:email => 'other@example.com') }

  scenario "Signing in as another user" do
    visit '/sessions/create'
    within("#session") do
      fill_in 'Email', :with => other_user.email
    end
    click_button 'Sign in'
    expect(page).to have_content 'Invalid email or password'
  end
end

require "rails_helper"

RSpec.feature "Widget management", :type => :feature do
  scenario "User creates a new widget" do
    visit "/widgets/new"

    fill_in "Name", :with => "My Widget"
    click_button "Create Widget"

    expect(page).to have_text("Widget was successfully created.")
  end
end
=end
require 'spec_helper'

feature "Signing in" do

  before do
    #Capybara.current_driver = :selenium
    valid_facebook_login_setup
    #login_with_oauth #call your helper method
  end

  scenario "Signing in with correct credentials" do
    expect(page).to have_content('Welcome')
  end
end

feature "Add project" do
  background do
    valid_facebook_login_setup
    visit '/auth/facebook/callback'
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