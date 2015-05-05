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

  # should move part of this to model
  def create
    @user = User.new(user_params)
	session[:signup] = true
	if @user.location && @user.location[:city] != ""
		@geokitResult = Geokit::Geocoders::GoogleGeocoder.geocode(
			@user.location[:city]+ " " + @user.location[:state])
		if @geokitResult.success
			@user.location[:c] = [@geokitResult.lng, @geokitResult.lat]
		elsif session[:coordinates]
		    @user.location[:c] = session[:coordinates].map &:to_f
		else 
			@user.location[:c] = [-41.3111, 72.9267]
		end
	elsif session[:coordinates]
		@user.location[:c] = session[:coordinates].map &:to_f		
	else 
		@user.location[:c] = [-41.3111, 72.9267]
    end
    
    if verify_recaptcha(model: @user, message: "Please retry the captcha.") && @user.save
       # Iff phone # given, make sure it's correct (but let continue)
      if !@user.contact[:phone].blank?
        @user.contact[:phone] = GlobalPhone.normalize(@user.contact[:phone])
        @phone = @user.contact[:phone]
        if !GlobalPhone.validate(@phone)
          # Put in flash alert about invalid United States phone #
          flash[:warning] = "Note: we were unable to automatically verify your phone number. Please check in your settings that it is correct."
        end
      end
      
      # Iff email addr given, make sure it's valid (but let continue)
      if !@user.contact[:email].blank?
        if !@user.mailgun_valid?(@user.contact[:email])
          flash[:warning] = "Note: we were unable to automatically verify your email address. Please check in your settings that it is correct."
        end
      end

      # Send a welcome email if we're in production
      if Rails.env.production?
        Notifier.welcome(@user).deliver
      end
      
      sign_in @user
      flash[:success] = "Welcome to TransHousing!"
      redirect_to @user
    else
      # If the captcha error is the only one, only give a captcha error.
      if @user.errors.messages.except(:base).all? { |k,v| v.empty? }
        error_message = @user.errors.messages[:base].first
      else 
        error_message = "Some of your input was invalid or missing." + 
        "Those fields are highlighted in red. " +
        "Please fill all fields appropriately and retry the captcha."
      end
      flash.now[:error] = error_message
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])

    if @user.update_attributes(edit_user_params)
      flash[:success] = "Success!"
      redirect_to @user
    else
      flash.now[:error] = "Please correct highlighted errors and try again."
      render 'edit'
    end
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
    signed_in_user
    @user = current_user
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
        :password, :password_confirmation,
        extended_profile_attributes:        [:profile_summary],
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
