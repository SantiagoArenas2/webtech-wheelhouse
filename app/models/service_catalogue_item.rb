class ServiceCatalogueItem < ApplicationRecord
  belongs_to :price_list
  # A service that has been charged on a repair is part of that repair's
  # record; it cannot be removed out from under it.
  has_many :repair_line_items, dependent: :restrict_with_error
  has_many :repairs, through: :repair_line_items, source: :repair_job

  before_validation :normalize_name

  scope :by_name, -> { order(:name) }

  validates :name, presence: true, uniqueness: { scope: :price_list_id }
  validates :list_price, presence: true, numericality: { greater_than: 0 }

  private

  def normalize_name
    self.name = name.strip if name.present?
  end
end
