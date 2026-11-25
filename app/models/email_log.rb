class EmailLog < ApplicationRecord
  belongs_to :bug
  enum :status, {pending: 0, sent: 1, failed: 2}, prefix: true, default: :pending
  validates :recipient_email, presence: true
  validates :email_key, presence: true, uniqueness: true
end
