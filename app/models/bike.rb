class Bike < ApplicationRecord
  belongs_to :customer
  has_many :repair_jobs, dependent: :destroy, inverse_of: :bike

  before_validation :normalize_serial_number

  scope :by_name, -> { order(:brand, :model) }

  validates :brand, presence: true
  validates :model, presence: true
  validates :serial_number, presence: true, uniqueness: true

  private

  # Bikes get logged by whoever is at the counter; typing "wtu123" and
  # "WTU 123 " should still collide with an existing serial number, so we
  # normalize before the uniqueness check runs.
  def normalize_serial_number
    self.serial_number = serial_number.strip.upcase if serial_number.present?
  end
end
