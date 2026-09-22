class ServicesController < ApplicationController
  def index
    current_price_list = PriceList.current.first

    @services = if current_price_list
      current_price_list.service_catalogue_items.by_name
    else
      ServiceCatalogueItem.none
    end
  end

  def show
    @service = ServiceCatalogueItem.includes(:price_list).find(params[:id])
    @repair_line_items = @service.repair_line_items.in_order.includes(repair_job: :bike)
  end
end
