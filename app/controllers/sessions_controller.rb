class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    session[:return_to] ||= request.referer
    redirect_to session.delete(:return_to)
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end