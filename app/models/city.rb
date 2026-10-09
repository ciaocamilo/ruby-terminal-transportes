class City < ApplicationRecord
  has_many :departures, class_name: "Trip", foreign_key: :origin_id, inverse_of: :origin, dependent: :restrict_with_error
  has_many :arrivals, class_name: "Trip", foreign_key: :destination_id, inverse_of: :destination, dependent: :restrict_with_error

  enum :status, { active: 0, inactive: 1 }, default: :active, validate: true

  normalizes :name, with: ->(name) { name.squish }

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :alphabetical, -> { order(:name) }

  def to_s = name
end
