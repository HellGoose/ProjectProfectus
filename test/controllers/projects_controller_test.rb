require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase

  # test "the truth" do
  #   assert true
  # end

  test "should get categories" do
    get :categories
    assert_response :success
  end

end
