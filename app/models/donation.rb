class Donation < ApplicationRecord
  belongs_to :campaign

  enum :frequency, { one_time: 0, monthly: 1 }
  enum :status, { pending: 0, paid: 1, cancelled: 2 }
  enum :display_preference, { full_name: 0, first_name: 1, anonymous: 2 }

  validates :amount, :donor_name, :donor_email, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :donor_email, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Resolves the donor's name for public display according to their chosen
  # `display_preference` (e.g. "Yosef S." for first-name-only, "אנונימי/ת"
  # for anonymous), so the "Recent donations" list never shows more than the
  # donor agreed to.
  def display_name
    case display_preference
    when "anonymous"
      "תורם/ת אנונימי/ת"
    when "first_name"
      first, *rest = donor_name.to_s.split
      rest.empty? ? first.to_s : "#{first} #{rest.last[0]}."
    else
      donor_name
    end
  end
end
