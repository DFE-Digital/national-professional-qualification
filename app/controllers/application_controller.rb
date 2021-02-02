class ApplicationController < ActionController::Base
  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

  helper_method :current_user, :admin_user?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def require_user!
    return if current_user

    redirect_to sign_in_path, flash: {error: "You are not authenticated"}
  end

  def admin_user?
    current_user.admin?
  end

  def go_to_dashboard_if_authenticated!
    redirect_to root_path if current_user
  end
end
