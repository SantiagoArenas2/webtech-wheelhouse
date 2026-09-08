class PagesController < ApplicationController
  def home
  end

  def services
    current_price_list = PriceList.where("effective_from <= ?", Date.current)
                                   .order(effective_from: :desc)
                                   .first

    @services = if current_price_list
      ServiceCatalogueItem.where(price_list_id: current_price_list.id).order(:name)
    else
      ServiceCatalogueItem.none
    end
  end

  def visit
  end

  def about
  end
end