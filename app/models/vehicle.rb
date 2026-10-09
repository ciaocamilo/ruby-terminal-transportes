class Vehicle < ApplicationRecord
  has_many :trips, dependent: :restrict_with_error

  enum :kind, { bus: 0, buseta: 1, microbus: 2, van: 3 }, default: :bus, validate: true
  enum :status, { available: 0, maintenance: 1, inactive: 2 }, default: :available, validate: true

  normalizes :plate, with: ->(plate) { plate.upcase.delete("^A-Z0-9") }
  normalizes :driver, with: ->(driver) { driver.squish }

  validates :plate, presence: true, uniqueness: true
  validates :driver, presence: true
  validates :capacity, numericality: { only_integer: true, in: 1..80 }
  validate :capacity_covers_booked_seats, if: :will_save_change_to_capacity?, on: :update

  scope :by_plate, -> { order(:plate) }

  def to_s = "#{plate} - #{driver}"

  private
    def capacity_covers_booked_seats
      highest_seat = Booking.active.joins(:trip).merge(trips.scheduled).maximum(:seat_number)
      if capacity && highest_seat && highest_seat > capacity
        errors.add(:capacity, :below_booked_seats, seat: highest_seat)
      end
    end
end
