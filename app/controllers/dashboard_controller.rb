class DashboardController < ApplicationController
  def index
    @trips_today = Trip.scheduled.on_date(Date.current).count
    @bookings_today = Booking.active.where(created_at: Date.current.all_day).count
    @available_vehicles = Vehicle.available.count
    @active_cities = City.active.count
    @upcoming_trips = Trip.upcoming.chronological.includes(:origin, :destination, :vehicle).limit(10)
  end
end
