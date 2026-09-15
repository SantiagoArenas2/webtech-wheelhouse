class RepairJob < ApplicationRecord
  belongs_to :bike
  belongs_to :customer
  belongs_to :received_by_staff, class_name: "StaffMember", foreign_key: :received_by_staff_id, inverse_of: :repair_jobs
  has_many :repair_line_items
end
