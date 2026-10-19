module Api
  module V1
    class RepairsController < BaseController
      before_action :authenticate_api_token!

      def index
        repairs = RepairJob.newest_first.includes(
          :bike,
          :customer,
          repair_line_items: :service_catalogue_item
        )

        if params.key?(:state)
          state = params[:state].to_s
          unless RepairJob.statuses.key?(state)
            states = RepairJob.statuses.keys.join(", ")
            raise ActionController::BadRequest, "Invalid state. Available states: #{states}."
          end

          repairs = repairs.where(status: state)
        end

        render json: repairs.map { |repair| repair_document(repair) }
      end

      def show
        repair = RepairJob.includes(
          :bike,
          :customer,
          repair_line_items: :service_catalogue_item
        ).find(params[:id])

        render json: repair_document(repair)
      end

      private

      def repair_document(repair)
        {
          id: repair.id,
          state: repair.status,
          received_on: repair.received_at.to_date.iso8601,
          promised_by: repair.promised_by&.iso8601,
          picked_up_on: repair.picked_up_at&.to_date&.iso8601,
          bike: {
            brand: repair.bike.brand,
            model: repair.bike.model,
            serial_number: repair.bike.serial_number
          },
          customer: { name: repair.customer.full_name },
          lines: repair.repair_line_items.map do |line|
            {
              service: line.service_catalogue_item.name,
              price: line.actual_price.nil? ? nil : format_price(line.actual_price),
              approved_by_customer: line.approved_by_customer
            }
          end,
          total: format_price(repair.total),
          overdue: repair.overdue?
        }
      end

      def format_price(price)
        format("%.2f", price)
      end
    end
  end
end