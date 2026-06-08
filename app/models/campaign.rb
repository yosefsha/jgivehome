class Campaign < ApplicationRecord
  has_many :donation_options, dependent: :destroy
  has_many :donations, dependent: :destroy

  validates :title, :story, :goal_amount, :slug, presence: true
  validates :slug, uniqueness: true
  validates :goal_amount, numericality: { greater_than: 0 }

  # Makes url helpers (campaign_path(campaign), new_campaign_donation_path(campaign), ...)
  # build slug-based URLs instead of falling back to the numeric id.
  def to_param
    slug
  end

  # Pending donations count toward progress: this demo has no payment
  # integration to ever flip them to "paid", so excluding pending would mean
  # the progress bar never visibly moves after a donation is submitted.
  # See README for the full rationale.
  def raised_amount
    donations.where(status: [ :pending, :paid ]).sum(:amount)
  end

  def progress_percentage
    return 0 if goal_amount.zero?

    (raised_amount / goal_amount * 100).round(1)
  end

  # Converts a youtube.com/watch or youtu.be link into YouTube's embeddable
  # iframe URL, so the banner can play the video in place rather than just
  # linking out to YouTube.
  def video_embed_url
    return if video_url.blank?

    video_id = video_url[/(?:youtu\.be\/|[?&]v=)([\w-]{11})/, 1]
    "https://www.youtube.com/embed/#{video_id}?autoplay=1&rel=0" if video_id
  end
end
