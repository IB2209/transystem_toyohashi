require "test_helper"

class SmartphoneControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get smartphone_index_url
    assert_response :success
  end
end
