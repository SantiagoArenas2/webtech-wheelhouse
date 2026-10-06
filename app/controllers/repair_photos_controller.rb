class RepairPhotosController < ApplicationController
  def destroy
    repair_job = RepairJob.find(params[:repair_job_id])
    repair_job.intake_photos_attachments.find(params[:id]).purge

    destination = params[:return_to] == "edit" ? edit_repair_path(repair_job) : repair_path(repair_job)
    redirect_to destination, notice: "The intake photo was removed.", status: :see_other
  end
end
