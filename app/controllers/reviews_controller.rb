class ReviewsController < ApplicationController

  def update
    @user = User.find(params[:user_id])
    @review = Review.find(params[:id])
    if @review.update_attributes(review_params)
      @user.sum_rating = @user.sum_rating + @review.rating
      @user.number_reviews = @user.number_reviews + 1
      @user.average_rating = (@user.sum_rating / @user.number_reviews).round(1)
      @user.save
      @review.update_attribute(:completed, 1)
      @review.update_attribute(:expirable_created_at, nil)
      #flash[:success] = "Review submitted"
      redirect_to @user
    else
      flash[:danger] = "Review not submitted"
      render 'edit'
    end
  end

  def edit
    @user = User.find(params[:user_id])
    if (@review = Review.find(params[:id])) && not(@review.completed) && signed_in? && current_user.id == @review.authorID
    else
      redirect_to @user
    end
  end


  def show
  end






  private

    def review_params
      params.require(:review).permit(:text, :rating)
    end



end
