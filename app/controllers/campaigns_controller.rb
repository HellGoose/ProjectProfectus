class CampaignsController < ApplicationController

	def index
		@campaigns = []#Campaign.all.order('voteCount DESC')
		@campaignsInterval = 8
	end

	def new
		@campaign = Campaign.new
	end

	def create
	end
end
