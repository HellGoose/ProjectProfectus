class HomeController < ApplicationController
	def index
		filteredProjects = Project.select("id, title, description, voteCount, logoLink").where("").order("voteCount DESC");
		@projects = filteredProjects.first(8);
		@mainPot = MainPot.find(1)
		@all_news = News.order("created_at DESC")
		@newsInterval = 5
	end

	def donate
		if current_user
			pot = MainPot.find(1)
			user = User.find(session[:user_id])
			amount = Integer(params[:amount])
			respond_to do |format|
				if user.money - amount >= 0
			        user.money -= amount
			        user.save
					pot.amount += amount
					pot.save
		      		msg = { :status => "ok", :message => pot.amount }
		      	else
		      		msg = { :status => 'Not enough money', :message => pot.amount}
		      	end
		      	format.json  { render :json => msg }
	    	end
	    end
	end
end
