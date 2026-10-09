class BookingsController < ApplicationController
  before_action :set_trip
  before_action :set_booking, only: %i[ show pay cancel ]
  before_action :authorize_change, only: %i[ pay cancel ]

  def new
    @booking = @trip.bookings.new(seat_number: params[:seat_number])
  end

  def create
    @booking = @trip.bookings.new(booking_params.merge(user: Current.user))

    if @booking.save
      redirect_to trip_booking_path(@trip, @booking), notice: "Pasaje vendido."
    else
      render :new, status: :unprocessable_content
    end
  rescue ActiveRecord::RecordNotUnique
    @booking.errors.add(:seat_number, :taken)
    render :new, status: :unprocessable_content
  end

  def show
  end

  def pay
    if @booking.reserved?
      @booking.paid!
      redirect_to trip_booking_path(@trip, @booking), notice: "Pasaje marcado como pagado.", status: :see_other
    else
      redirect_to trip_booking_path(@trip, @booking), alert: "Solo se pueden pagar pasajes reservados.", status: :see_other
    end
  end

  def cancel
    if @booking.cancelled?
      redirect_to @trip, alert: "El pasaje ya estaba cancelado.", status: :see_other
    else
      @booking.cancel!
      redirect_to @trip, notice: "Pasaje cancelado.", status: :see_other
    end
  end

  private
    def set_trip
      @trip = Trip.find(params.expect(:trip_id))
    end

    def set_booking
      @booking = @trip.bookings.find(params.expect(:id))
    end

    def booking_params
      params.expect(booking: [ :passenger_name, :passenger_document, :seat_number, :status ])
    end

    def authorize_change
      unless admin? || @booking.user == Current.user
        redirect_to trip_booking_path(@trip, @booking), alert: "Solo el vendedor o un administrador puede modificar este pasaje."
      end
    end
end
