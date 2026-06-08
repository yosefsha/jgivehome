class Donation < ApplicationRecord
  belongs_to :campaign

  enum :frequency, { one_time: 0, monthly: 1 }
  enum :status, { pending: 0, paid: 1, cancelled: 2 }
  enum :display_preference, { full_name: 0, first_name: 1, anonymous: 2 }

  validates :amount, :donor_name, :donor_email, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :donor_email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
