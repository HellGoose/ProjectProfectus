require 'spec_helper'

describe "GET '/auth/facebook/callback'" do

  before(:each) do
    login_with_oauth(build(:user))
  end
  
  it "should set user_id" do
    puts(User.last.id)
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
    login_with_oauth(build(:user))
    get '/auth/facebook/callback'
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
    login_with_oauth(build(:user))
    get '/auth/facebook/callback'
  end

  it "should return response.status 200" do
    get '/users/'+session[:user_id].to_s
    expect(response.status).to eq(200)
  end
end