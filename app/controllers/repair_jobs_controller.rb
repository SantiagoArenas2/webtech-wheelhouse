class RepairJobsController < ApplicationController
  NEW_LINE_ITEM_SLOTS = 4
  EXTRA_LINE_ITEM_SLOTS_ON_EDIT = 2

  before_action :set_repair_job, only: [ :show, :edit, :update, :destroy ]
  before_action :load_form_collections, only: [ :new, :edit, :create, :update ]

  def index
    @repair_jobs = RepairJob.newest_first.includes(:bike, :customer)
      .with_attached_intake_photos.with_rich_text_diagnosis
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
    @repair_job = RepairJob.new
    assign_repair_job_attributes
    @repair_job.customer_id = @repair_job.bike&.customer_id

    if @repair_job.save
      attach_intake_photos
      redirect_to @repair_job, notice: "Repair ##{@repair_job.id} was created."
    else
      EXTRA_LINE_ITEM_SLOTS_ON_EDIT.times { @repair_job.repair_line_items.build }
      render :new, status: :unprocessable_entity
    end
  end

  def update
    assign_repair_job_attributes
    @repair_job.customer_id = @repair_job.bike&.customer_id

    if @repair_job.save
      attach_intake_photos
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
    @repair_job = RepairJob.with_attached_intake_photos.with_rich_text_diagnosis
      .includes(:bike, :customer, :received_by_staff).find(params[:id])
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
      :received_at, :ready_at, :picked_up_at, :diagnosis, { intake_photos: [] },
      repair_line_items_attributes: [[ :id, :service_catalogue_item_id, :quoted_price, :actual_price, :approved_by_customer, :notes, :_destroy ]]
    ])
  end

  def assign_repair_job_attributes
    attributes = repair_job_params
    @repair_job.intake_photo_uploads = attributes.delete(:intake_photos)
    @repair_job.assign_attributes(attributes)
  end

  def attach_intake_photos
    uploads = Array(@repair_job.intake_photo_uploads).compact_blank
    @repair_job.intake_photos.attach(uploads) if uploads.any?
  end
end
