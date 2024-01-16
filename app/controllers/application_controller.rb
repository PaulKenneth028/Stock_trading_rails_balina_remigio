class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:admin, :first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end

  def after_sign_in_path_for(resource)
    if resource.admin? 
      admin_dashboard_path(id: current_user.id)
    else
     resource.status == 'approved' ? user_dashboard_path : pending_path
    end
  end

  # def check_user_application
  #   return unless user_signed_in?

  #   if current_user.admin?
  #     return
  #   end

  #   if current_user.approved?
  #     redirect_to after_sign_in_path_for(current_user) unless request.path == new_user_session_path
  #   else
  #     redirect_to root_path, notice: 'Please wait until your application is approved.' 
  #   end
  # end
end
