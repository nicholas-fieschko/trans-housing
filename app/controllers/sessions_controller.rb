class SessionsController < ApplicationController
  def new
  end

  def create
    # Todo: change to allow signing in through alternative contact than email as well
    user = Contact.where(email: params[:session][:email].downcase).first.user
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
