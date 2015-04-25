class UsersController < ApplicationController
  def new
    if signed_in?
      redirect_to root_url
    end
    @user = User.new
    @user.build_contact
    # @user.build_location(zip: "06511",city: "New Haven",state: "CT")
    @user.build_location(session[:location])
	@user.build_gender
  end

  def create
    @user = User.new(user_params)

    @user.location[:coordinates] = session[:coordinates]

    if !@user.gender[:cp]
      @user.gender[:cp] = nil
      @user.gender[:they] = nil
      @user.gender[:them] = nil
      @user.gender[:their] = nil
    end

    @user.food_resource = params[:user][:food_resource] == "1" ? true : false
    @user.shower_resource = params[:user][:shower_resource] == "1" ? true : false
    @user.laundry_resource = params[:user][:laundry_resource] == "1" ? true : false
    @user.housing_resource = params[:user][:housing_resource] == "1" ? true : false
    @user.transportation_resource = params[:user][:transportation_resource] == "1" ? true : false
    @user.buddy_resource = params[:user][:buddy_resource] == "1" ? true : false

    if @user.save

      # Send an email upon signup--will go to Stephen's email because of
			# Fabricator settings, so comment out until the demo.
      # Notifier.welcome(@user).deliver

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
  	@reviews = @user.reviews
  end


  def dashboard
    if signed_in?
      @user = current_user
      @reviews = Review.where(authorID: @user.id, completed: false).all
    else
      signed_in_user
    end
  end

  private

    def user_params
      params.require(:user).permit(
        :name,
        :is_provider,
        :password, :password_confirmation,
        gender_attributes:  [:identity, :trans, :cp, :they, :their, :them],
        contact_attributes: [:email, :phone],
        location_attributes: [:coordinates,:zip,:city,:state]
        )
    end

end
