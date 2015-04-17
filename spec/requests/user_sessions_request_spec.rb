require 'spec_helper'

describe "GET '/auth/facebook/callback'" do

  before(:each) do
    valid_facebook_login_setup
    get '/auth/facebook/callback'
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end

  it "should set user_id" do
    expect(session[:user_id]).to eq(User.last.id)
  end

  it "should redirect to root" do
    expect(response).to redirect_to root_path
  end
end

describe "GET '/auth/failure'" do

  it "should redirect to root" do
    get "/auth/failure"
    expect(response).to redirect_to root_path
  end
end

describe "GET '/signout'" do
  before(:each) do
    valid_facebook_login_setup
    get '/auth/facebook/callback'
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    get "/signout"
  end

  it "should set session[user_id] to nil" do
    expect(session[:user_id]).to eq(nil)
  end

  it "should redirect to root" do
    expect(response).to redirect_to root_path
  end
end

describe "GET '/users/:user_id'" do
  before(:each) do
    valid_facebook_login_setup
    get '/auth/facebook/callback'
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end

  it "should return response.status 200" do
    get '/users/'+session[:user_id].to_s
    expect(response.status).to eq(200)
  end

  # it "should redirect to user account page" do

  # end
end

# describe "GET 'user/:user_id/edit'" do
#   it "should ..." do
#   end
# end