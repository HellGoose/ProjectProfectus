require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
<<<<<<< HEAD
  # test "the truth" do
  #   assert true
  # end
=======
  test "should get categories" do
    get :categories
    assert_response :success
  end

>>>>>>> 6ba1baa58ca6d0860568b7ff18c774e69ee5d920
end
