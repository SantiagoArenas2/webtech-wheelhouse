class RepairJobsController < ApplicationController
  NEW_LINE_ITEM_SLOTS = 4
  EXTRA_LINE_ITEM_SLOTS_ON_EDIT = 2

  before_action :set_repair_job, only: [ :show, :edit, :update, :destroy ]
  before_action :load_form_collections, only: [ :new, :edit, :create, :update ]

  def index
    @repair_jobs = RepairJob.newest_first.includes(:bike, :customer)
  end

  def show
    @repair_line_items = @repair_job.repair_line_items.in_order.includes(:service_catalogue_item)
  end

  def new
    @repair_job = RepairJob.new(bike_id: params[:bike_id])
    NEW_LINE_ITEM_SLOTS.times { @repair_job.repair_line_items.build }
  end

  def edit
    EXTRA_LINE_ITEM_SLOTS_ON_EDIT.times { @repair_job.repair_line_items.build }
  end

  def create
    @repair_job = RepairJob.new(repair_job_params)
    @repair_job.customer_id = @repair_job.bike&.customer_id

    if @repair_job.save
      redirect_to @repair_job, notice: "Repair ##{@repair_job.id} was created."
    else
      EXTRA_LINE_ITEM_SLOTS_ON_EDIT.times { @repair_job.repair_line_items.build }
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @repair_job.assign_attributes(repair_job_params)
    @repair_job.customer_id = @repair_job.bike&.customer_id

    if @repair_job.save
      redirect_to @repair_job, notice: "Repair ##{@repair_job.id} was updated."
    else
      EXTRA_LINE_ITEM_SLOTS_ON_EDIT.times { @repair_job.repair_line_items.build }
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @repair_job.destroy
      redirect_to repairs_path, notice: "Repair ##{@repair_job.id} was removed.", status: :see_other
    else
      redirect_to @repair_job, alert: @repair_job.errors.full_messages.to_sentence, status: :see_other
    end
  end

  private

  def set_repair_job
    @repair_job = RepairJob.includes(:bike, :customer, :received_by_staff).find(params[:id])
  end

  def load_form_collections
    @bikes = Bike.by_name.includes(:customer)
    @staff_members = StaffMember.by_name
    current_price_list = PriceList.current.first
    @services = current_price_list ? current_price_list.service_catalogue_items.by_name : ServiceCatalogueItem.none
  end

  def repair_job_params
    params.expect(repair_job: [
      :bike_id, :received_by_staff_id, :status, :promised_by,
      :received_at, :ready_at, :picked_up_at,
      repair_line_items_attributes: [[ :id, :service_catalogue_item_id, :quoted_price, :actual_price, :approved_by_customer, :notes, :_destroy ]]
    ])
  end
end
