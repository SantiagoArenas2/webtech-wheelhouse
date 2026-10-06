class BikesController < ApplicationController
  before_action :set_bike, only: [ :show, :edit, :update, :destroy ]
  before_action :load_form_collections, only: [ :new, :edit, :create, :update ]

  def index
    @bikes = Bike.by_name.includes(:customer)
  end

  def show
    @repair_jobs = @bike.repair_jobs.newest_first.includes(:customer)
      .with_attached_intake_photos.with_rich_text_diagnosis
  end

  def new
    @bike = Bike.new(customer_id: params[:customer_id])
  end

  def edit
  end

  def create
    @bike = Bike.new(bike_params)

    if @bike.save
      redirect_to @bike, notice: "#{@bike.brand} #{@bike.model} (#{@bike.serial_number}) was added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @bike.update(bike_params)
      redirect_to @bike, notice: "#{@bike.brand} #{@bike.model} (#{@bike.serial_number}) was updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @bike.destroy
      redirect_to bikes_path, notice: "#{@bike.serial_number} was removed.", status: :see_other
    else
      redirect_to @bike, alert: @bike.errors.full_messages.to_sentence, status: :see_other
    end
  end

  private

  def set_bike
    @bike = Bike.includes(:customer).find(params[:id])
  end

  def load_form_collections
    @customers = Customer.by_name
  end

  def bike_params
    params.expect(bike: [ :brand, :model, :serial_number, :customer_id ])
  end
end
