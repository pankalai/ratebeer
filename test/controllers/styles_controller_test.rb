require "test_helper"

class StylesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get styles_new_url
    assert_response :success
  end

  test "should get create" do
    get styles_create_url
    assert_response :success
  end
end
