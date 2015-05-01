class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  
  #before_filter :login_required
  #protected
  #def login_required
  #	redirect_to root_url unless signed_in?
  #end
  
end
