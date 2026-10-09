class Booking < ApplicationRecord
  belongs_to :trip
  belongs_to :user

  enum :status, { reserved: 0, paid: 1, cancelled: 2 }, default: :reserved, validate: true

  normalizes :passenger_name, with: ->(name) { name.squish }
  normalizes :passenger_document, with: ->(document) { document.strip }

  validates :passenger_name, :passenger_document, presence: true
  validates :seat_number, numericality: { only_integer: true, greater_than: 0 }
  validates :seat_number, uniqueness: { scope: :trip_id, conditions: -> { active } }, unless: :cancelled?
  validates :status, exclusion: { in: %w[cancelled] }, on: :create
  validate :seat_within_capacity
  validate :trip_open_for_booking, on: :create

  scope :active, -> { where.not(status: :cancelled) }
  scope :by_seat, -> { order(:seat_number) }

  def cancel!
    update!(status: :cancelled)
  end

  private
    def seat_within_capacity
      return unless trip && seat_number

      errors.add(:seat_number, :exceeds_capacity, capacity: trip.vehicle.capacity) if seat_number > trip.vehicle.capacity
    end

    def trip_open_for_booking
      errors.add(:trip, :not_bookable) if trip && !trip.bookable?
    end
end
