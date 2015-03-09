class HomeController < ApplicationController
	def index
		filteredProjects = Project.select("id, title, description, voteCount, logoLink").where("").order("voteCount DESC");
		@projects = filteredProjects.first(8);
		@mainPot = MainPot.find(1)
		@all_news = News.first(10)
	end

	def donate
		pot = MainPot.find(1)
		pot.amount += 5
		pot.save
		respond_to do |format|
      		msg = { :status => "ok", :message => pot.amount }
      		format.json  { render :json => msg }
    	end
	end
end
