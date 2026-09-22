class CustomersController < ApplicationController
  def index
    @customers = Customer.by_name
  end

  def show
    @customer = Customer.find(params[:id])
    @bikes = @customer.bikes.by_name.includes(:customer)
  end
end
