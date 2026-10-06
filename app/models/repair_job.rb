class RepairJob < ApplicationRecord
  INTAKE_PHOTO_MAX_SIZE = 5.megabytes
  INTAKE_PHOTO_CONTENT_TYPES = %w[image/jpeg image/png].freeze

  enum :status, {
    received: "received",
    awaiting_diagnosis: "awaiting_diagnosis",
    quote_ready: "quote_ready",
    awaiting_customer_approval: "awaiting_customer_approval",
    in_progress: "in_progress",
    ready_for_pickup: "ready_for_pickup",
    picked_up: "picked_up",
    declined: "declined"
  }

  belongs_to :bike, inverse_of: :repair_jobs
  belongs_to :customer
  belongs_to :received_by_staff, class_name: "StaffMember", foreign_key: :received_by_staff_id, inverse_of: :repair_jobs

  has_many :repair_line_items, dependent: :destroy
  has_many :services, through: :repair_line_items, source: :service_catalogue_item
  has_many_attached :intake_photos, dependent: :purge_later do |photos|
    photos.variant :thumbnail, resize_to_fill: [ 120, 90 ]
    photos.variant :display, resize_to_limit: [ 1200, 1200 ]
  end
  has_rich_text :diagnosis

  attr_accessor :intake_photo_uploads

  accepts_nested_attributes_for :repair_line_items,
    reject_if: proc { |attrs| attrs["service_catalogue_item_id"].blank? },
    allow_destroy: true

  scope :newest_first, -> { order(received_at: :desc) }
  scope :open, -> { where.not(status: statuses[:picked_up]) }
  scope :overdue, -> { open.where("promised_by < ?", Date.current) }

  validates :status, presence: true
  validates :received_at, presence: true

  validate :repair_dates_are_in_order
  validate :status_matches_recorded_events
  validate :intake_photos_are_valid

  def overdue?
    !picked_up? && promised_by.present? && promised_by < Date.current
  end

  def total
    repair_line_items.sum { |line| line.actual_price || line.quoted_price || 0 }
  end

  private

  def repair_dates_are_in_order
    return if received_at.blank?

    if picked_up_at.present? && picked_up_at.to_date < received_at.to_date
      errors.add(:picked_up_at, "can't be before the day the bike was received")
    end

    if promised_by.present? && promised_by < received_at.to_date
      errors.add(:promised_by, "can't be before the day the bike was received")
    end
  end

  def status_matches_recorded_events
    if !picked_up? && picked_up_at.present?
      errors.add(:picked_up_at, "can only be recorded once the repair has been picked up")
    end

    if customer_answer_expected? && quoted_line_item_missing_answer?
      errors.add(:base, "Every quoted service on this repair needs the customer's answer recorded once it has moved past the quote step")
    end
  end

  def customer_answer_expected?
    in_progress? || ready_for_pickup? || picked_up? || declined?
  end

  def quoted_line_item_missing_answer?
    repair_line_items.any? { |line| line.quoted_price.present? && line.approved_by_customer.nil? }
  end

  def intake_photos_are_valid
    Array(intake_photo_uploads).compact_blank.each do |upload|
      filename = upload.original_filename
      content_type = Marcel::MimeType.for(upload.tempfile, name: filename)

      unless INTAKE_PHOTO_CONTENT_TYPES.include?(content_type)
        errors.add(:intake_photos, "#{filename} must be a JPEG or PNG image")
      end

      if upload.size > INTAKE_PHOTO_MAX_SIZE
        errors.add(:intake_photos, "#{filename} must be no larger than 5 MB")
      end
    end
  end
end
