class ApplicationController < ActionController::Base
  def login_required
    unless current_user
      redirect_to login_url, notice: "Please sign in"
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user
end
