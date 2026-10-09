class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :bookings, dependent: :restrict_with_error

  enum :role, { seller: 0, admin: 1 }, default: :seller, validate: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
