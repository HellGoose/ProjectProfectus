class ProjectsController < ApplicationController
	def index
		@projects = Project.all
	end

	def categories
	end

end
