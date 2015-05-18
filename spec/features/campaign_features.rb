$campaign_links = [
  'https://www.kickstarter.com/projects/597711793/experience-the-commonwealth-of-new-island?ref=category_featured',
  'https://www.kickstarter.com/projects/1561531723/montclair-bread-co?ref=category_featured',
  'https://www.kickstarter.com/projects/766361157/sjmat-pa-dra?ref=category_location',
  'https://www.kickstarter.com/projects/boxfortgames/bowbarian?ref=category_featured',
  'https://www.kickstarter.com/projects/bishopgames/light-fall-escape-the-light-embrace-the-night?ref=category_recommended',
  'https://www.kickstarter.com/projects/2012515236/coup-rebellion-g54?ref=category_popular',
  'https://www.kickstarter.com/projects/1559949250/mongrel?ref=category_location',
  'https://www.kickstarter.com/projects/rosscowman/fall-of-magic-a-role-playing-game-of-profound-fant?ref=category',
  'https://www.kickstarter.com/projects/level99games/millennium-blades-the-ccg-simulator-board-game?ref=category',
  'https://www.kickstarter.com/projects/loneshark/the-apocrypha-adventure-card-game?ref=category',
  'https://www.kickstarter.com/projects/1078944858/lord-of-the-dead-an-asymmetrical-hex-and-counter-m?ref=category',
  'https://www.kickstarter.com/projects/udoo/udoo-neo-raspberry-pi-arduino-wi-fi-bt-40-sensors?ref=category_featured',
  'https://www.kickstarter.com/projects/1598272670/chip-the-worlds-first-9-computer?ref=category_recommended',
  'https://www.kickstarter.com/projects/967143816/building-powerful-customized-gaming-pcs-with-your?ref=category_location',
  'https://www.kickstarter.com/projects/alpinelabs/radian-2-bluetooth-time-lapse-motion-and-camera-co?ref=category_popular',
  'https://www.kickstarter.com/projects/cobattery/cobattery-never-plug-in-your-iphone-again?ref=category',
  'https://www.indiegogo.com/projects/still-life-cycling',
  'https://www.indiegogo.com/projects/other-side-of-the-wind-orson-welles-last-film',
  'https://life.indiegogo.com/fundraisers/mouth-and-heart-for-rich',
  'https://www.indiegogo.com/projects/zami-life-the-future-of-sitting',
  'https://www.indiegogo.com/projects/diy-girls-summer-camp',
  'https://www.indiegogo.com/projects/project-hyena-diorama',
  'https://www.indiegogo.com/projects/wallet-drone-world-s-smallest-quadcopter',
  'https://www.indiegogo.com/projects/best-18650-batteries-for-vapers-as-of-may-2015',
  'https://www.indiegogo.com/projects/joggy-security-cam',
  'https://www.indiegogo.com/projects/neo-neural-efficiency-optimizer-neurophone',
  'https://www.indiegogo.com/projects/soundbrenner-pulse-wearable-device-for-musicians',
  'https://www.indiegogo.com/projects/codie-cute-personal-robot-that-makes-coding-fun',
  'https://www.indiegogo.com/projects/master-beta-kit-easy-erotic-engineering--2',
  'https://www.indiegogo.com/projects/goze-your-true-life-journey-curated',
  'https://www.indiegogo.com/projects/imbrief-a-briefcase-as-smart-stylish-as-you-are'
]

feature "Delete existing campaign" do
  before do
    @user = create(:user)
    @campaign = create(:campaign, user_id: @user.id, link: $campaign_links.pop)
    login_with_oauth(@user)
  end
  scenario "by clicking delete", :js => true do
    click_on @user.name
    click_on 'account'
    visit "/users/"+@user.id.to_s
    visit "/campaigns/"+@user.campaigns.first.id.to_s
    click_on 'Delete'
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_text("Campaign was successfully destroyed.")
  end
end

feature "Add new campaign" do
  before do
    @user = build(:user)
    login_with_oauth(@user)
    #@campaign = build(:campaign, user_id: @user.id)
  end
  scenario "by creating a campaign", :js => true do
    click_on 'Add Campaign'
    fill_in 'campaign_link', :with => $campaign_links.pop#@campaign.link
    click_on 'submitButton'
    expect(page).to have_text("Campaign was successfully created.")
  end
end

feature "Add new campaign" do
  before do
    @user = build(:user)
    login_with_oauth(@user)
    #@campaign = build(:campaign, user_id: @user.id)
    create(:category, name: "category1")
    create(:category, name: "category2")
  end
  scenario "and set category to category2", :js => true do
    click_on 'Add Campaign'
    fill_in 'campaign_link', :with => $campaign_links.pop#@campaign.link
    select "category2", :from => "campaign_category_id"
    click_on 'submitButton'
    expect(page).to have_text("Campaign was successfully created.")
  end
end

feature "View all campaigns" do
  before do
    @user = build(:user)
    login_with_oauth(@user)
    #@campaign = build(:campaign, user_id: @user.id)
    click_on 'Add Campaign'
    fill_in 'campaign_link', :with => $campaign_links.pop#@campaign.link
    click_on 'submitButton'
  end
  scenario "by clicking 'campaigns' in navbar", :js => true do
    click_on 'Campaigns'
    expect(page).to have_css('div#campaigns')
  end
end

feature "Filter campaigns by category" do
  before do
    @user = build(:user)
    login_with_oauth(@user)
    #@campaign = build(:campaign, user_id: @user.id)
    for i in 1..2
      create(:category, name: "category"+i.to_s)
      click_on 'Add Campaign'
      puts $campaign_links[i-1]
      fill_in 'campaign_link', :with => $campaign_links[i-1]#@campaign.link
      select "category"+i.to_s, :from => "campaign_category_id"
      click_on 'submitButton'
    end
  end
  scenario "by clicking 'campaigns' and '<category>'", :js => true do
    click_on "Campaigns"
    click_on "category1"
    expect(page).to have_css('div.col-xs-3.campaign')
  end
end

feature "Campaign voting" do
  before do
    @voter = create(:user, name:"Kari")
    login_with_oauth(@voter)
    create(:category, name:"category")
    for i in 0..20
      user = create(:user, name: "Ola"+(i+1).to_s)
      create(:campaign, user_id: user.id)
    end
    create(:round)
  end
  scenario "by going through voting process", :js => true do
    #click_on "start-voting"
    page.find(:xpath, '//*[@id="start-voting"]').click
    for i in 0..3
      page.find(:xpath, '//*[@id='+Random.rand(0..2).to_s+']/a').click
      page.find(:xpath, '//*[@id="next-voting"]').click
    end
    expect(page).to have_text('Done Voting')
  end
end