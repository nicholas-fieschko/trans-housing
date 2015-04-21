class UsersController < ApplicationController
  def new
    @user = User.new
    @user.build_contact
    @user.location = Fabricate.build(:location)
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
    @users = User.all
    @users = User.search(params[:search])

    if params[:users_filters]
      @users = User.find_with_filters(params[:users_filters])
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

    def user_params
      params.require(:user).permit(
        :name,
        :is_provider,
        :password, :password_confirmation,
        gender_attributes:  [:identity, :trans, :cp, :they, :their, :them],
        contact_attributes: [:email, :phone]
        # location_attributes: [:coordinates],
        )
    end
end
