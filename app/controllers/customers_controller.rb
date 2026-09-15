class CustomersController < ApplicationController
  def index
    @customers = Customer.order(:full_name)
  end

  def show
    @customer = Customer.find(params[:id])
  end
end
