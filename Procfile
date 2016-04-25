web: bundle exec puma -C config/puma.rb
poller_worker: rake runscript:poller QUEUE=poller VERBOSE=true
bot_worker: rake runscript:botTest QUEUE=botTest VERBOSE=true
#scraper_worker: rake runscript:scraper QUEUE=scraper VERBOSE=true
