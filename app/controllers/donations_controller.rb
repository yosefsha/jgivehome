class DonationsController < ApplicationController
  before_action :set_campaign

  def new
    @donation = @campaign.donations.build
  end

  def create
    @donation = @campaign.donations.build(donation_params)
    @donation.status = :pending

    if @donation.save
      redirect_to campaign_path(@campaign), notice: "תודה! התרומה שלך התקבלה והיא ממתינה לאישור."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_campaign
    @campaign = Campaign.find_by!(slug: params[:campaign_slug])
  end

  def donation_params
    params.require(:donation)
          .permit(:amount, :custom_amount, :frequency, :donor_name, :donor_email,
                  :display_preference, :dedication_message)
          .then { |attrs| resolve_amount(attrs) }
  end

  # The form offers preset amount tiles plus a free-form "other amount" field;
  # whichever one the donor actually filled in becomes the donation amount.
  def resolve_amount(attrs)
    custom_amount = attrs.delete(:custom_amount)
    attrs[:amount] = custom_amount if custom_amount.present?
    attrs
  end
end
