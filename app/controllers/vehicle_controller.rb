class VehicleController < ApplicationController

  def create
    if request.post?
      vehicle = Vehicle.create(placa: params[:placa], conductor: params[:conductor], tipo: params[:tipo], estado: params[:estado])
      redirect_to "/vehicle/view/" + vehicle.id.to_s 
    end
  end

  def view
    @vehicle = Vehicle.find_by(id: params[:id])
  end

  def show
    @vehicles = Vehicle.all
  end

  def delete
    vehicle = Vehicle.find_by(id: params[:id])
    vehicle.destroy
    redirect_to "/vehicle/show/" 
  end

  def update
    if request.post? 
      vehicle = Vehicle.find_by(id: params[:id])
      vehicle.update(placa: params[:placa], conductor: params[:conductor], tipo: params[:tipo], estado: params[:estado])
      redirect_to "/vehicle/view/" + vehicle.id.to_s 
    else
      @vehicle = Vehicle.find_by(id: params[:id])
    end
  end

end
