class CitiesController < ApplicationController
  admin_only except: %i[ index show ]
  before_action :set_city, only: %i[ show edit update destroy ]

  def index
    @pagy, @cities = pagy(City.alphabetical)
  end

  def show
    @upcoming_trips = Trip.upcoming.where(origin: @city).or(Trip.upcoming.where(destination: @city))
      .includes(:origin, :destination, :vehicle).chronological.limit(10)
  end

  def new
    @city = City.new
  end

  def edit
  end

  def create
    @city = City.new(city_params)

    if @city.save
      redirect_to @city, notice: "Ciudad creada."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @city.update(city_params)
      redirect_to @city, notice: "Ciudad actualizada.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    if @city.destroy
      redirect_to cities_path, notice: "Ciudad eliminada.", status: :see_other
    else
      redirect_to @city, alert: @city.errors.full_messages.to_sentence, status: :see_other
    end
  end

  private
    def set_city
      @city = City.find(params.expect(:id))
    end

    def city_params
      params.expect(city: [ :name, :status ])
    end
end
