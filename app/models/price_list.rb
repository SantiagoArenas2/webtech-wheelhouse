class PriceList < ApplicationRecord
  has_many :service_catalogue_items, dependent: :destroy

  scope :current, -> { where("effective_from <= ?", Date.current).order(effective_from: :desc) }

  validates :year, presence: true, uniqueness: true
  validates :effective_from, presence: true
end
