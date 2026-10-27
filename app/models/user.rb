class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  belongs_to :staff_member, optional: true, inverse_of: :user

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  generates_token_for :password_reset, expires_in: 15.minutes do
    password_salt&.last(10)
  end

  enum :role, {
    mechanic: "mechanic",
    counter: "counter",
    owner: "owner"
  }, default: :mechanic

  validates :email_address, presence: true,
    format: { with: URI::MailTo::EMAIL_REGEXP },
    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 10 }, if: -> { password.present? }
end
