class RepairJobsController < ApplicationController
  def index
    @repair_jobs = RepairJob.newest_first.includes(:bike, :customer)
  end

  def show
    @repair_job = RepairJob.includes(:bike, :customer, :received_by_staff).find(params[:id])
    @repair_line_items = @repair_job.repair_line_items.in_order.includes(:service_catalogue_item)
  end
end
