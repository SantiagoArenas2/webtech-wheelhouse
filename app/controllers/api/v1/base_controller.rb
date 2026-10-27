module Api
  module V1
    class BaseController < ActionController::API
      include ActionController::HttpAuthentication::Token::ControllerMethods

      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from ActionController::ParameterMissing,
        ActionController::BadRequest,
        ActionDispatch::Http::Parameters::ParseError,
        with: :render_bad_request

      private

      def authenticate_api_token!
        expected_token = Rails.application.credentials.dig(:api, :token)

        authenticate_or_request_with_http_token do |token, _options|
          expected_token.present? && ActiveSupport::SecurityUtils.secure_compare(token, expected_token)
        end
      end

      def request_http_token_authentication(_realm = "Application", _message = nil)
        render json: { errors: [ "Unauthorized" ] }, status: :unauthorized
      end

      def render_not_found
        render json: { errors: [ "Record not found" ] }, status: :not_found
      end

      def render_bad_request(exception)
        render json: { errors: [ exception.message ] }, status: :bad_request
      end
    end
  end
end