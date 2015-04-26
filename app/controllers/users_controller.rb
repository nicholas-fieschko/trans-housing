class UsersController < ApplicationController
  def new
    if signed_in?
      redirect_to root_url
    end
    @user = User.new
    @user.build_contact
    @user.build_location(session[:location])
    @user.build_gender

    @user.build_food_resource
    @user.build_shower_resource
    @user.build_laundry_resource
    @user.build_housing_resource
    @user.build_transportation_resource
    @user.build_buddy_resource
  end

  def create
    @user = User.new(user_params)

    @user.location[:coordinates] = session[:coordinates].map &:to_f

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
    # @users = User.search(params[:search])

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
        location_attributes: [:c,:zip,:city,:state],
        food_resource_attributes: [:currently_offered],
        shower_resource_attributes: [:currently_offered],
        laundry_resource_attributes: [:currently_offered],
        housing_resource_attributes: [:currently_offered],
        transportation_resource_attributes: [:currently_offered],
        buddy_resource_attributes: [:currently_offered]
        )
    end

end
