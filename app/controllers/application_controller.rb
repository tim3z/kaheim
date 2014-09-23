class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  delegate :tm, to: :view_context

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  after_filter :store_location

  def authenticate_admin_user!
    authenticate_user!
    unless current_user.admin?
      flash[:alert] = "Unauthorized Access!"
      redirect_to root_path
    end
  end

  def store_location
    if request.path != new_user_session_path &&
      request.path != new_user_registration_path &&
      request.path != new_user_password_path &&
      request.path != edit_user_password_path &&
      request.path != user_confirmation_path &&
      request.path != destroy_user_session_path &&
      !request.xhr? # don't store ajax calls
      store_location_for(:user, request.original_url)
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:account_update) << :name
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    (I18n.locale == :de) ? {} : {locale: I18n.locale}
  end
end
