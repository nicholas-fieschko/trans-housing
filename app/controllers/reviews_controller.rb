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

  end

  def test
  	if signed_in?
	  	@user = User.find(params[:user_id])
	  	@review = @user.reviews.create!(authorID: current_user.id, author: current_user.name)
	  	@review.create_token_digest
	else
		signed_in_user
	end
  end




end
