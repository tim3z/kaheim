class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by ignoring the session
  protect_from_forgery
  delegate :tm, to: :view_context

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  after_action :store_location

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
      request.path != destroy_user_session_path &&
      !request.xhr? # don't store ajax calls
      store_location_for(:user, request.original_url)
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def set_locale
    I18n.locale = locale_param || I18n.default_locale
  end

  def locale_param
    I18n.available_locales.map(&:to_s).include?(params[:locale]) ? params[:locale] : nil
  end

  def default_url_options(options = {})
    (I18n.locale == :de) ? options : options.merge(locale: I18n.locale)
  end

  def verify_captcha
    return false unless params[:stupid_captcha]
    (params[:stupid_captcha].downcase.include?("jesus") || params[:stupid_captcha].downcase.include?("christ")) &&
      params[:stupid_captcha].length < 20
  end

  def owner_show_item_path(item)
    if item.is_a?(Offer)
      owner_show_offer_path(item, token: item.owner_show_token)
    elsif item.is_a?(Request)
      owner_show_request_path(item, token: item.owner_show_token)
    end
  end

end
