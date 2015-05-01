class ReviewsController < ApplicationController

  def update
    @user = User.find(params[:user_id])
    @review = Review.find(params[:id])
    check_reviewer_id
    if @review.update_attributes(review_params)
      if !@review.completed
        @review.set_complete
        @user.update_attribute(:sum_rating, @user.sum_rating + @review.rating)
        @user.update_attribute(:number_reviews, @user.number_reviews + 1)
        @user.update_attribute(:average_rating, (@user.sum_rating.to_f / @user.number_reviews).round(1))
      end
      #flash[:success] = "Review submitted"
      redirect_to @user
    else
      flash[:danger] = "Review not submitted"
      render 'edit'
    end
  end
  

  def edit
    @user = User.find(params[:user_id])
    @review = Review.find(params[:id])
    check_reviewer_id
  end


  private

    def review_params
      params.require(:review).permit(:text, :rating)
    end

    def check_reviewer_id
      signed_in_user
      if current_user.id != @review.reviewer_id
        flash[:warning] = "Sorry, only the designated reviewer has permission to edit this review"
        redirect_to @user
      end
    end


end
