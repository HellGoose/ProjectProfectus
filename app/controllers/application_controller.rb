class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :isAdmin

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def isAdmin
  	if current_user != nil
  		current_user.role > 1
  	else
  		false
  	end
  end
end