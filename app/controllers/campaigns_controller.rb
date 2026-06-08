class CampaignsController < ApplicationController
  def show
    @campaign = Campaign.find_by!(slug: params[:slug])
  end
end
