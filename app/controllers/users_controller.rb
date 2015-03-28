class UsersController < ApplicationController
  def new
  end

  def update
  end

  def index
  end

  def show
  	@user = User.find(params[:id])
  end

end
