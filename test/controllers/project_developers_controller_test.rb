require "test_helper"

class ProjectDevelopersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get project_developers_index_url
    assert_response :success
  end
end
