require "test_helper"

class Api::V1::RepairsControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated repair requests always receive a JSON error" do
    get api_v1_repairs_url, headers: { "Accept" => "text/html" }

    assert_response :unauthorized
    assert_equal "application/json", response.media_type
    assert_equal({ "errors" => [ "Unauthorized" ] }, response.parsed_body)
  end
end