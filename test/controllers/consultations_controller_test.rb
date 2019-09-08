require 'test_helper'

class ConsultationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get consultations_index_url
    assert_response :success
  end

end
