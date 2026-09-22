class StaffMembersController < ApplicationController
  def index
    @staff_members = StaffMember.by_name
  end

  def show
    @staff_member = StaffMember.find(params[:id])
    @repair_jobs = @staff_member.repair_jobs.newest_first.includes(:bike, :customer)
  end
end
