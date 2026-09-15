class ServiceCatalogueItem < ApplicationRecord
  belongs_to :price_list
  has_many :repair_line_items
end
