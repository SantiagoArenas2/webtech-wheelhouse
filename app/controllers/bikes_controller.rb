class BikesController < ApplicationController
  def index
    @bikes = Bike.order(:brand, :model)
  end

  def show
    @bike = Bike.find(params[:id])
  end
end
