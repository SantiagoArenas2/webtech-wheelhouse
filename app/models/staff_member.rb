class StaffMember < ApplicationRecord
  has_many :repair_jobs, foreign_key: :received_by_staff_id, inverse_of: :received_by_staff
end
