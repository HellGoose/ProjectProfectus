namespace :runscript do
	#desc "Scraper"
	#task :scraper => :environment do
	#	APP_ROOT = File.expand_path(File.dirname(File.dirname(__FILE__)))

	#	require APP_ROOT + '/tasks/scraper.rb'
	#	scraper = Scraper.new
	#	scraper.start
	#end

	desc "Poller"
	task :poller => :environment do
		APP_ROOT = File.expand_path(File.dirname(File.dirname(__FILE__)))

		require APP_ROOT + '/tasks/workerscript.rb'
		databaseInit()
		roundScript()
	end	
end
