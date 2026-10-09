class VehiclesController < ApplicationController
  admin_only except: %i[ index show ]
  before_action :set_vehicle, only: %i[ show edit update destroy ]

  def index
    @pagy, @vehicles = pagy(Vehicle.by_plate)
  end

  def show
    @upcoming_trips = @vehicle.trips.upcoming.includes(:origin, :destination, :vehicle).chronological.limit(10)
  end

  def new
    @vehicle = Vehicle.new
  end

  def edit
  end

  def create
    @vehicle = Vehicle.new(vehicle_params)

    if @vehicle.save
      redirect_to @vehicle, notice: "Vehículo creado."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @vehicle.update(vehicle_params)
      redirect_to @vehicle, notice: "Vehículo actualizado.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    if @vehicle.destroy
      redirect_to vehicles_path, notice: "Vehículo eliminado.", status: :see_other
    else
      redirect_to @vehicle, alert: @vehicle.errors.full_messages.to_sentence, status: :see_other
    end
  end

  private
    def set_vehicle
      @vehicle = Vehicle.find(params.expect(:id))
    end

    def vehicle_params
      params.expect(vehicle: [ :plate, :driver, :kind, :capacity, :status ])
    end
end
