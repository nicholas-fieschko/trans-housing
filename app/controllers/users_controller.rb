class UsersController < ApplicationController
	include Geokit::Geocoders
	
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
	if session[:location] && session[:location]["city"] != "Unknown Location"
		session[:coordinates] = Geokit::Geocoders::GoogleGeocoder.geocode(
			session[:location]["city"])
	end

    @user.location[:coordinates] = session[:coordinates].map &:to_f

   
    
    if verify_recaptcha(model: @user, message: "Robot!!") && @user.save

       # Iff phone # given, make sure it's correct (but let continue)
      if @user.contact[:phone]
        @user.contact[:phone] = GlobalPhone.normalize(@user.contact[:phone])
        @phone = @user.contact[:phone]
        if !GlobalPhone.validate(@phone)
          # Put in flash alert about invalid United States phone #
          flash[:error] = "WARNING: Invalid phone number"
        end
      end

      # Iff email addr given, make sure it's valid (but let continue)
      if @user.contact[:email]
        if !@user.mailgun_valid?(@user.contact[:email])
          flash[:error] = "WARNING: Invalid email address"
        end
      end

      # Send an email upon signup--will go to Stephen's email because of
			# Fabricator settings, so comment out until the demo.
      # Notifier.welcome(@user).deliver

      sign_in @user

      redirect_to @user
    else
      # Put in a flash alert with the captcha error message
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(edit_user_params)
      flash[:success] = "Successfully updated settings."
      redirect_to @user
    else
      render 'edit'
    end
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
        gender_attributes:                  [:identity, :trans, :cp,
                                              :they, :their, :them],
        contact_attributes:                 [:email, :phone],
        location_attributes:                [:c,:zip,:city,:state],
        food_resource_attributes:           [:currently_offered],
        shower_resource_attributes:         [:currently_offered],
        laundry_resource_attributes:        [:currently_offered],
        housing_resource_attributes:        [:currently_offered],
        transportation_resource_attributes: [:currently_offered],
        buddy_resource_attributes:          [:currently_offered]
        )
    end

    def edit_user_params
      params.require(:user).permit(
        :name,
        # :is_provider,
        :password, :password_confirmation,
        # gender_attributes:                [:identity, :trans, :cp,
        #                                     :they, :their, :them],
        contact_attributes:                 [:email, :phone],
        location_attributes:                [:c,:zip,:city,:state],
        food_resource_attributes:           [:currently_offered],
        shower_resource_attributes:         [:currently_offered],
        laundry_resource_attributes:        [:currently_offered],
        housing_resource_attributes:        [:currently_offered],
        transportation_resource_attributes: [:currently_offered],
        buddy_resource_attributes:          [:currently_offered],
        misc_resource_attributes:           [:currently_offered]
        )
    end

end
