class StaffMembersController < ApplicationController
  before_action :set_staff_member, only: [ :show, :edit, :update, :destroy ]

  def index
    @staff_members = StaffMember.by_name
  end

  def show
    @repair_jobs = @staff_member.repair_jobs.newest_first.includes(:bike, :customer)
  end

  def new
    @staff_member = StaffMember.new
  end

  def edit
  end

  def create
    @staff_member = StaffMember.new(staff_member_params)

    if @staff_member.save
      redirect_to @staff_member, notice: "#{@staff_member.full_name} was added to staff."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @staff_member.update(staff_member_params)
      redirect_to @staff_member, notice: "#{@staff_member.full_name}'s details were updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @staff_member.destroy
      redirect_to staff_members_path, notice: "#{@staff_member.full_name} was removed from staff.", status: :see_other
    else
      redirect_to @staff_member, alert: @staff_member.errors.full_messages.to_sentence, status: :see_other
    end
  end

  private

  def set_staff_member
    @staff_member = StaffMember.find(params[:id])
  end

  def staff_member_params
    params.expect(staff_member: [ :full_name, :role ])
  end
end
