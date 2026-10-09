class TripsController < ApplicationController
  admin_only except: %i[ index show ]
  before_action :set_trip, only: %i[ show edit update destroy ]

  def index
    @filters = params.permit(:origin_id, :destination_id, :date, :status, :page)
    @cities = City.alphabetical
    @pagy, @trips = pagy(Trip.search(@filters).includes(:origin, :destination, :vehicle).order(departure_at: :desc))
  end

  def show
    @bookings = @trip.bookings.includes(:user).by_seat
  end

  def new
    @trip = Trip.new
    load_form_options
  end

  def edit
    load_form_options
  end

  def create
    @trip = Trip.new(trip_params)

    if @trip.save
      redirect_to @trip, notice: "Viaje creado."
    else
      load_form_options
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @trip.update(trip_params)
      redirect_to @trip, notice: "Viaje actualizado.", status: :see_other
    else
      load_form_options
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    if @trip.destroy
      redirect_to trips_path, notice: "Viaje eliminado.", status: :see_other
    else
      redirect_to @trip, alert: @trip.errors.full_messages.to_sentence, status: :see_other
    end
  end

  private
    def set_trip
      @trip = Trip.find(params.expect(:id))
    end

    def trip_params
      params.expect(trip: [ :departure_at, :fare, :status, :vehicle_id, :origin_id, :destination_id ])
    end

    # Keeps the trip's current (possibly inactive) vehicle and cities selectable when editing.
    def load_form_options
      @vehicles = Vehicle.available.or(Vehicle.where(id: @trip.vehicle_id)).by_plate
      @cities = City.active.or(City.where(id: [ @trip.origin_id, @trip.destination_id ])).alphabetical
    end
end
