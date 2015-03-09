class HomeController < ApplicationController
	def index
		filteredProjects = Project.select("id, title, description, voteCount, logoLink").where("").order("voteCount DESC");
		@projects = filteredProjects.first(8)
		@all_news = News.first(10)
	end
end
