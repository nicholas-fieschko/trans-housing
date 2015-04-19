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
  	@user = User.find(params[:id])
  	if params[:review]
	  	@review = @user.reviews.detect { |r| r.id.to_s == params[:review_id] }
    	if @review.update_attributes(review_params)
    		@user.number_reviews = @user.number_reviews + 1
    		@user.save
    		@review.update_attribute(:completed, 1)
        @review.update_attribute(:expirable_created_at, nil)
	    	flash[:success] = "Review submitted"
      		redirect_to @user
	    else
	    	flash[:danger] = "Review not submitted"
	        render 'show'
	    end
	else
    end
  end

  def index
  end

  def show
  	@user = User.find(params[:id])
  	@reviews = @user.reviews
  end


  private

    def review_params
      params.require(:review).permit(:text, :rating)
    end

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
