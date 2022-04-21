class TripController < ApplicationController

  def create
    if request.post?
      trip = Trip.create(fecha_hora: params[:fecha_hora], valor_pasaje: params[:valor_pasaje], vehicle_id: params[:vehicle_id], origin_id: params[:origin_id], destiny_id: params[:destiny_id], estado: params[:estado])
      redirect_to "/trip/view/" + trip.id.to_s 
    end
  end

  def view
    @trip = Trip.find_by(id: params[:id])
  end

  def show
    @cities = Trip.all
  end

  def delete
    trip = Trip.find_by(id: params[:id])
    trip.destroy
    redirect_to "/trip/show/" 
  end

  def update
    if request.post? 
      trip = Trip.find_by(id: params[:id])
      trip.update(fecha_hora: params[:fecha_hora], valor_pasaje: params[:valor_pasaje], vehicle_id: params[:vehicle_id], origin_id: params[:origin_id], destiny_id: params[:destiny_id], estado: params[:estado])
      redirect_to "/trip/view/" + trip.id.to_s 
    else
      @trip = Trip.find_by(id: params[:id])
    end
  end

end
