class ReviewsController < ApplicationController
  def new
  end

  def update
  end

  def index
  end

  def show
  end

  def create
  	@user = User.find(params[:user_id])
  	@user.reviews.create!(review_params)  
    redirect_to user_path(params[:user_id])
    
  	
  end


  private

    def review_params
      params.require(:review).permit(:author, :text, :rating)
    end


end
