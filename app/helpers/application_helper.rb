module ApplicationHelper
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

  def status_label(repair_job)
    repair_job.status.humanize
  end

  def status_badge_class(repair_job)
    case
    when repair_job.received? || repair_job.awaiting_diagnosis?
      "text-bg-secondary"
    when repair_job.quote_ready?
      "text-bg-info"
    when repair_job.awaiting_customer_approval?
      "text-bg-warning"
    when repair_job.in_progress?
      "text-bg-primary"
    when repair_job.ready_for_pickup?
      "text-bg-success"
    when repair_job.picked_up?
      "text-bg-dark"
    when repair_job.declined?
      "text-bg-danger"
    end
  end
end
