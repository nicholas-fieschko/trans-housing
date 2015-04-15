class UsersController < ApplicationController
  def new
    @user = User.new
    @user.build_contact
    @user.location = Location.new
    @user.build_gender
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      redirect_to @user
    else
      render 'new'
    end
  end

  def update
  end

  def index
  end

  def show
    @user = User.find(params[:id])
  end

  private

    def user_params
      params.require(:user).permit(:name, :is_provider,
        :password, :password_confirmation,
        gender_attributes: [:identity, :trans, :cp, :they, :their, :them], 
        contact_attributes: [:email, :phone])
    end
end
