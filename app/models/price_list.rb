class PriceList < ApplicationRecord
  has_many :service_catalogue_items, dependent: :destroy

  # The published list in effect today: the most recent one whose start
  # date has already arrived.
  scope :current, -> { where("effective_from <= ?", Date.current).order(effective_from: :desc) }

  validates :year, presence: true, uniqueness: true
  validates :effective_from, presence: true
end
