require 'test_helper'
require 'helpers/omni_auth_test_helper'

class SessionsControllerTest < ActionController::TestCase
  #describe "GET '/auth/facebook/callback'" do
  include OmniAuthTestHelper

  test "GET '/auth/facebook/callback' should set user_id" do
    valid_facebook_login_setup
    #get 'auth/facebook/callback'
    #request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    get 'create'
    assert_equal(session[:user_id], User.last.id)
  end

  test "GET '/auth/facebook/callback' should redirect to root" do
    valid_facebook_login_setup
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    get '/auth/facebook/callback'
    assert_redirected_to root_path
  end

  #describe "GET '/auth/failure'" do 
  test "GET '/auth/failure' should redirect to root" do
    get 'auth/failure'
    assert_redirected_to root_path
  end
end