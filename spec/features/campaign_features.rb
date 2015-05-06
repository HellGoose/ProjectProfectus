# feature "Delete existing campaign" do
#   before do
#     @user = create(:user)
#     @campaign = create(:campaign, user_id: @user.id)
#     login_with_oauth(@user)
#   end
#   scenario "by clicking delete", :js => true do
#     click_on @user.name
#     click_on 'account'
#     visit "/users/"+@user.id.to_s
#     visit "/campaigns/"+@user.campaigns.first.id.to_s
#     click_on 'Delete'
#     page.driver.browser.switch_to.alert.accept
#     expect(page).to have_text("Campaign was successfully destroyed.")
#   end
# end

# feature "Add new campaign" do
#   before do
#     @user = build(:user)
#     login_with_oauth(@user)
#     @campaign = build(:campaign, user_id: @user.id)
#   end
#   scenario "by creating a campaign", :js => true do
#     click_on 'Add Campaign'
#     fill_in 'campaign_link', :with => @campaign.link
#     click_on 'Create Campaign'
#     expect(page).to have_text("Campaign was successfully created.")
#   end
# end

# feature "Add new campaign" do
#   before do
#     @user = build(:user)
#     login_with_oauth(@user)
#     @campaign = build(:campaign, user_id: @user.id)
#     create(:category, name: "category1")
#     create(:category, name: "category2")
#   end
#   scenario "and set category to category2", :js => true do
#     click_on 'Add Campaign'
#     fill_in 'campaign_link', :with => @campaign.link
#     select "category2", :from => "campaign_category_id"
#     click_on 'Create Campaign'
#     expect(page).to have_text("Campaign was successfully created.")
#   end
# end

# feature "View all campaigns" do
#   before do
#     @user = build(:user)
#     login_with_oauth(@user)
#     @campaign = build(:campaign, user_id: @user.id)
#     click_on 'Add Campaign'
#     fill_in 'campaign_link', :with => @campaign.link
#     click_on 'Create Campaign'
#   end
#   scenario "by clicking 'campaigns' in navbar", :js => true do
#     click_on 'Campaigns'
#     expect(page).to have_css('div#campaigns')
#   end
# end

# feature "Filter campaigns by category" do
#   before do
#     @user = build(:user)
#     login_with_oauth(@user)
#     @campaign = build(:campaign, user_id: @user.id)
#     for i in 1..2
#       create(:category, name: "category"+i.to_s)
#       click_on 'Add Campaign'
#       fill_in 'campaign_link', :with => @campaign.link
#       select "category"+i.to_s, :from => "campaign_category_id"
#       click_on 'Create Campaign'
#     end
#   end
#   scenario "by clicking 'campaigns' and '<category>'", :js => true do
#     click_on "Campaigns"
#     click_on "category2"
#     expect(page).to have_css('div.col-xs-3.campaign')
#   end
# end

feature "Campaign voting" do
  before do
    @voter = create(:user, name:"Kari")
    login_with_oauth(@voter)
    create(:category, name:"category")
    for i in 0..20
      user = create(:user, name: "Ola"+(i+1).to_s)
      create(:campaign, user_id: user.id)
    end
  end
  scenario "by going through voting process", :js => true do
    #click_on "start-voting"
    page.find(:xpath, '//*[@id="start-voting"]').click

    page.find(:xpath, '//*[@id='+Random.rand(0..2).to_s+']/a').click
    page.find(:xpath, '//*[@id="next-voting"]')
    # click_on //*[@id="start-voting"]
    #page.all("div.col-xs-3.campaign")#.sample.click
    #within('div.col-xs-12') do
      # click_on
      # Random.rand(1..4)
    #end
    #click_on "next-voting"
    expect(page).to have_css('div.col-xs-3.campaign')
  end
end