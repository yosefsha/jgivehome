class DonationOption < ApplicationRecord
  belongs_to :campaign

  validates :amount, :label, presence: true
  validates :amount, numericality: { greater_than: 0 }
end
