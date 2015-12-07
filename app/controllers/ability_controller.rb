class AbilityController < ApplicationController
	def report
		if !current_user || !currentUserHasAbility
			redirect_to '/'
			return
		end

		if !current_user.reports.exists?(campaign_id: session[:campaign_id])
			campaign = Campaign.find(session[:campaign_id])
			current_user.reports.create(
				user_id: current_user.id,
				campaign_id: campaign.id,
				round: current_round + 1,
				nominated: campaign.nominated
				)
			campaign.reported += 1
			campaign.save
		end

		redirect_to "/campaigns/#{@campaign.id}"
	end

	def star
		if !current_user || !currentUserHasAbility
			redirect_to "/campaigns/#{@campaign.id}"
			return
		end

		campaign = Campaign.find(session[:campaign_id])
		allreadyStared = current_user.stars.exists?(round: current_round + 1, campaign_id: campaign.id)
		haveStarSlotsLeft = current_user.stars.where(round: current_round+1).count < 3

		if  !allreadyStared && haveStarSlotsLeft
			current_user.stars.create(
				user_id: current_user.id,
				campaign_id: campaign.id,
				round: current_round + 1
				)
		elsif allreadyStared
			current_user.stars.find_by(round: current_round + 1, campaign_id: campaign.id).destroy
		end

		redirect_to "/campaigns/#{@campaign.id}"
	end
end
