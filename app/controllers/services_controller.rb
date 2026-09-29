class ServicesController < ApplicationController
  before_action :set_service, only: [ :show, :edit, :update, :destroy ]
  before_action :load_form_collections, only: [ :new, :edit, :create, :update ]

  def index
    current_price_list = PriceList.current.first

    @services = if current_price_list
      current_price_list.service_catalogue_items.by_name
    else
      ServiceCatalogueItem.none
    end
  end

  def show
    @repair_line_items = @service.repair_line_items.in_order.includes(repair_job: :bike)
  end

  def new
    @service = ServiceCatalogueItem.new
  end

  def edit
  end

  def create
    @service = ServiceCatalogueItem.new(service_params)

    if @service.save
      redirect_to @service, notice: "#{@service.name} was added to the price list."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @service.update(service_params)
      redirect_to @service, notice: "#{@service.name} was updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @service.destroy
      redirect_to services_path, notice: "#{@service.name} was removed.", status: :see_other
    else
      redirect_to @service, alert: @service.errors.full_messages.to_sentence, status: :see_other
    end
  end

  private

  def set_service
    @service = ServiceCatalogueItem.includes(:price_list).find(params[:id])
  end

  def load_form_collections
    @price_lists = PriceList.by_year
  end

  def service_params
    params.expect(service_catalogue_item: [ :name, :list_price, :price_list_id ])
  end
end
