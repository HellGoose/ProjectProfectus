class PledgeController < ApplicationController
  def show
    render params[:pledge]
  end
end