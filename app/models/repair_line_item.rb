class RepairLineItem < ApplicationRecord
  belongs_to :repair_job
  belongs_to :service_catalogue_item
end
