module ApplicationHelper
  STATUS_BADGE_CLASSES = {
    "received" => "text-bg-secondary",
    "awaiting_diagnosis" => "text-bg-secondary",
    "quote_ready" => "text-bg-info",
    "awaiting_customer_approval" => "text-bg-warning",
    "in_progress" => "text-bg-primary",
    "ready_for_pickup" => "text-bg-success",
    "picked_up" => "text-bg-dark",
    "declined" => "text-bg-danger"
  }.freeze

  def format_money(amount)
    return "—" if amount.nil?

    number_to_currency(amount)
  end

  def format_day(date)
    return "—" if date.nil?

    date.strftime("%b %-d, %Y")
  end

  def format_instant(datetime)
    return "—" if datetime.nil?

    datetime.strftime("%b %-d, %Y %-l:%M %p")
  end

  def status_label(status)
    status.humanize
  end

  def status_badge_class(status)
    STATUS_BADGE_CLASSES.fetch(status, "text-bg-secondary")
  end

  def repair_overdue?(repair_job)
    repair_job.promised_by.present? &&
      repair_job.picked_up_at.nil? &&
      repair_job.promised_by < Date.current
  end
end
