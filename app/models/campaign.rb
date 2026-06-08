class Campaign < ApplicationRecord
  has_many :donation_options, dependent: :destroy
  has_many :donations, dependent: :destroy

  validates :title, :story, :goal_amount, :slug, presence: true
  validates :slug, uniqueness: true
  validates :goal_amount, numericality: { greater_than: 0 }

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
end
