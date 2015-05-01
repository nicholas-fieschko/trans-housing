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
    session[:location] = @user.location
    if session[:location] && session[:location]["city"] != "Unknown Location"
      @geokitResult = Geokit::Geocoders::GoogleGeocoder.geocode(
                                                                session[:location]["city"]+ " " + session[:location]["state"])
      if @geokitResult.success
        session[:coordinates] = [@geokitResult.lng, @geokitResult.lat]
        # Below is added by nick after invalid location resulted in nil session coords.
        # else
        #   session[:coordinates] = [41.31845, -72.92226]
      end
    end
    
    @user.location[:coordinates] = session[:coordinates].map &:to_f
    
    
    if verify_recaptcha(model: @user, message: "Robot!!") && @user.save
      
      # Iff phone # given, make sure it's correct (but let continue)
      if @user.contact[:phone]
        @user.contact[:phone] = GlobalPhone.normalize(@user.contact[:phone])
        @phone = @user.contact[:phone]
        if !GlobalPhone.validate(@phone)
          # Put in flash alert about invalid United States phone #
          flash[:warning] = "Note: we were unable to automatically verify your phone number. Please check in your settings that it is correct."
        end
      end
      
      # Iff email addr given, make sure it's valid (but let continue)
      if @user.contact[:email]
        if !@user.mailgun_valid?(@user.contact[:email])
          flash[:warning] = "Note: we were unable to automatically verify your email address. Please check in your settings that it is correct."
        end
      end

      # Send a welcome email if we're in production
      if Rails.env.production?
        Notifier.welcome(@user).deliver
      end
      
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
