class DonationOption < ApplicationRecord
  belongs_to :campaign

  # One row per preset amount a Campaign offers (each with its own label/messaging
  # and an optional `featured` "most chosen" badge), so tiers vary per campaign and
  # are seed/admin-editable data rather than view-layer constants.

  validates :amount, :label, presence: true
  validates :amount, numericality: { greater_than: 0 }
end
