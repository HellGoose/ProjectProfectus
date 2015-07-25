class StatDumpController < ApplicationController
	def show
		@statDump = StatDump.find(params[:id])
	end
end