module Api
  module V1
    class ServicesController < BaseController
      before_action :authenticate_api_token!, only: :create

      def index
        current_price_list = PriceList.current.first
        @services = if current_price_list
          current_price_list.service_catalogue_items.by_name.includes(:repair_line_items)
        else
          ServiceCatalogueItem.none
        end

        render json: @services.map { |service| service_document(service) }
      end

      def show
        service = ServiceCatalogueItem.includes(:repair_line_items).find(params[:id])
        render json: service_document(service)
      end

      def create
        service = ServiceCatalogueItem.new(service_params)

        if service.save
          render json: service_document(service), status: :created,
            location: api_v1_service_url(service)
        else
          render json: { errors: service.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def service_document(service)
        {
          id: service.id,
          name: service.name,
          price: format_price(service.list_price),
          repair_count: service.repair_line_items.filter_map do |line|
            line.repair_job_id if line.actual_price.present?
          end.uniq.size
        }
      end

      def format_price(price)
        format("%.2f", price)
      end

      def service_params
        attributes = params.expect(service_catalogue_item: [ :name, :list_price, :price_list_id ])
        raise ActionController::ParameterMissing, :service_catalogue_item if attributes.empty?

        attributes
      end
    end
  end
end