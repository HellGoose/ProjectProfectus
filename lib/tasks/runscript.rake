namespace :runscript do
	desc "Poller"
	task :poller => :environment do
		APP_ROOT = File.expand_path(File.dirname(File.dirname(__FILE__)))
		require APP_ROOT + '/tasks/workerscript.rb'
		databaseInit()
		roundScript()
	end
end