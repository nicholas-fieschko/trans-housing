class UsersController < ApplicationController
  def new
  end

  def update
  	@user = User.find(params[:id])
  	if params[:review]
	  	@review = @user.reviews.detect { |r| r.id.to_s == params[:review_id] }
    	if @review.update_attributes(review_params)
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
  end


  private

    def review_params
      params.require(:review).permit(:author, :text, :rating)
    end


end
