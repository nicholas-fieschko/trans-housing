class SessionsController < ApplicationController
  def new
  end

  def create
    if params[:session][:username].include? '@'
      user = Contact.where(email: params[:session][:username].downcase).first.user
    else
      user = Contact.where(phone: params[:session][:username].downcase).first.user
    end
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

end