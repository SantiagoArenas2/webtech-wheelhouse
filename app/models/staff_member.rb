class StaffMember < ApplicationRecord
  has_many :repair_jobs,
    foreign_key: :received_by_staff_id,
    inverse_of: :received_by_staff,
    dependent: :restrict_with_error

  scope :by_name, -> { order(:full_name) }

  validates :full_name, presence: true
  validates :role, presence: true
end
