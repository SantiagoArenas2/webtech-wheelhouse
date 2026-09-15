class RepairJobsController < ApplicationController
  def index
    @repair_jobs = RepairJob.order(received_at: :desc)
  end

  def show
    @repair_job = RepairJob.find(params[:id])
  end
end
