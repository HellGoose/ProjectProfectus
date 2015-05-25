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
    save_screenshot('spec/features/screenshots/view_list_of_campaigns.png')
    expect(page).to have_css('div#campaigns')
  end
end