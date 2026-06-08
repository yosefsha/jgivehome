class DonationsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_campaign

  def new
    @donation = @campaign.donations.build
  end

  def create
    @donation = @campaign.donations.build(donation_params)
    @donation.status = :pending

    if @donation.save
      broadcast_campaign_updates
      redirect_to campaign_path(@campaign), notice: "תודה! התרומה שלך התקבלה והיא ממתינה לאישור."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # Pushes the new totals and the new donation to everyone currently viewing
  # the campaign page (via the `turbo_stream_from @campaign` subscription),
  # so the progress bar, raised amount, donor count, and "Recent donations"
  # list update live for them without a reload — the submitter's own page
  # gets there anyway via the post-redirect full-page visit.
  def broadcast_campaign_updates
    @campaign.broadcast_replace_to(@campaign,
      target: dom_id(@campaign, :stats),
      partial: "campaigns/stats",
      locals: { campaign: @campaign })

    @donation.broadcast_prepend_to(@campaign,
      target: dom_id(@campaign, :recent_donations),
      partial: "donations/donation",
      locals: { donation: @donation })

    # Removes the "no donations yet" placeholder once the first one lands.
    @campaign.broadcast_remove_to(@campaign, target: dom_id(@campaign, :no_donations))
  end

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
