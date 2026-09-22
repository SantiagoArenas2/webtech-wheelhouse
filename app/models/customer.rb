class Customer < ApplicationRecord
  has_many :bikes, dependent: :restrict_with_error
  has_many :repair_jobs, dependent: :restrict_with_error
  has_many :bike_repairs, through: :bikes, source: :repair_jobs

  scope :by_name, -> { order(:full_name) }

  validates :full_name, presence: true
  validates :phone, presence: true
end
