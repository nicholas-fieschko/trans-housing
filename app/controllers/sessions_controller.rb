class SessionsController < ApplicationController
  def new
  end

  def create
    method = (params[:session][:username].include? '@') ? "email" : "phone"
    contact_record = Contact.where(method.to_sym => params[:session][:username].downcase).first
    if contact_record && contact_record.user.authenticate(params[:session][:password])
      sign_in contact_record.user
      redirect_back_or contact_record.user
    else
      flash.now[:error] = 'Entered credentials do not match any registered accounts.'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

end