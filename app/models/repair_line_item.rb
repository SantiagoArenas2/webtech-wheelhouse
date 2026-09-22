class RepairLineItem < ApplicationRecord
  belongs_to :repair_job
  belongs_to :service_catalogue_item

  scope :in_order, -> { order(:id) }

  validates :quoted_price, numericality: { greater_than: 0 }, allow_nil: true
  validates :actual_price, numericality: { greater_than: 0 }, allow_nil: true
end
