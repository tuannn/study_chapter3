class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  before_filter :set_locale
 
  def set_locale
    #cookies[:remember_locale] = I18n.locale
    if(params[:locale])
	  cookies.permanent[:remember_locale] = params[:locale] 
	end   
    I18n.locale = cookies[:remember_locale] || 	I18n.default_locale
	#I18n.locale = params[:locale] || 	I18n.default_locale.to_s
  end
  
  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end
end
