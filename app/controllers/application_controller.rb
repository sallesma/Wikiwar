class ApplicationController < ActionController::Base
    protect_from_forgery
    helper_method :current_user
    before_filter :set_locale

    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end

    def default_url_options(options = {})
      { locale: I18n.locale }.merge options
    end

    private

    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
        @current_user ||= User.find_by_authentication_token(cookies[:auth_token]) if cookies[:auth_token] && @current_user.nil?
        @current_user
    end

    def authenticate_user
      if current_user.nil?
        flash[:error] = t(:not_signed_in)
        redirect_to :root
      end
    end
end
