class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :isAdmin

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def isAdmin
  	current_user.role > 1
  end
end