class PlacesController < ApplicationController
  def index
  end

  def search
    session[:city] = params[:city]
    @places = BeermappingApi.places_in(params[:city])
    @weather = WeatherApi.weather_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index, status: 418
    end
  end

  def show
    @place = BeermappingApi.places_in(session[:city]).select{ |place| place["id"] == params[:id] }.first
  end
end
