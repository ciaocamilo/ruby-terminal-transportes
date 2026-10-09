class Trip < ApplicationRecord
  belongs_to :vehicle
  belongs_to :origin, class_name: "City"
  belongs_to :destination, class_name: "City"
  has_many :bookings, dependent: :restrict_with_error

  enum :status, { scheduled: 0, in_progress: 1, finished: 2, cancelled: 3 }, default: :scheduled, validate: true

  validates :departure_at, presence: true
  validates :fare, numericality: { greater_than: 0 }
  validate :destination_differs_from_origin
  validate :vehicle_available, if: -> { vehicle && will_save_change_to_vehicle_id? }

  scope :chronological, -> { order(:departure_at) }
  scope :upcoming, -> { scheduled.where(departure_at: Time.current..) }
  scope :from_city, ->(city_id) { where(origin_id: city_id) if city_id.present? }
  scope :to_city, ->(city_id) { where(destination_id: city_id) if city_id.present? }
  scope :on_date, ->(date) { where(departure_at: date.all_day) if date }
  scope :with_status, ->(status) { where(status:) if statuses.key?(status) }

  def self.search(filters)
    date = Date.iso8601(filters[:date].to_s) rescue nil
    from_city(filters[:origin_id]).to_city(filters[:destination_id]).on_date(date).with_status(filters[:status])
  end

  def route = "#{origin} → #{destination}"

  def taken_seats
    bookings.active.pluck(:seat_number)
  end

  def seats_left
    vehicle.capacity - bookings.active.count
  end

  def bookable?
    scheduled? && departure_at.future? && seats_left.positive?
  end

  private
    def destination_differs_from_origin
      errors.add(:destination, :same_as_origin) if origin_id.present? && origin_id == destination_id
    end

    def vehicle_available
      errors.add(:vehicle, :unavailable) unless vehicle.available?
    end
end
