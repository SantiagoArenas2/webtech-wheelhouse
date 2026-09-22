class BikesController < ApplicationController
  def index
    @bikes = Bike.by_name.includes(:customer)
  end

  def show
    @bike = Bike.includes(:customer).find(params[:id])
    @repair_jobs = @bike.repair_jobs.newest_first.includes(:customer)
  end
end
