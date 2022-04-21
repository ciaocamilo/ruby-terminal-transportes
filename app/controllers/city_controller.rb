class CityController < ApplicationController

  def create
    if request.post?
      city = City.create(nombre: params[:nombre], estado: params[:estado])
      redirect_to "/city/view/" + city.id.to_s 
    end
  end

  def view
    @city = City.find_by(id: params[:id])
  end

  def show
    @cities = City.all
  end

  def delete
    city = City.find_by(id: params[:id])
    city.destroy
    redirect_to "/city/show/" 
  end

  def update
    if request.post? 
      city = City.find_by(id: params[:id])
      city.update(nombre: params[:nombre], estado: params[:estado])
      redirect_to "/city/view/" + city.id.to_s 
    else
      @city = City.find_by(id: params[:id])
    end
  end
  
end
