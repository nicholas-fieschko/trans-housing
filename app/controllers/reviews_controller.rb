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
  	@user = User.find(params[:user_id])
  	@review = @user.reviews.create!
  	@review.create_token_digest
  end




end
