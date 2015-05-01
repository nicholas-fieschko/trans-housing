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



  rescue_from Mongoid::Errors::DocumentNotFound, :with => :record_not_found

  def record_not_found
    #raise ActionController::RoutingError.new('Not Found')
    flash[:warning] = "Sorry, not found in database"
    redirect_to root_url
  end

  	
end
