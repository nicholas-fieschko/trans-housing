class RequestsController < ApplicationController
  def new
    if signed_in?
      @helpee = current_user
      @helper = User.find(params[:user_id])
      check_provider_status
    else
      signed_in_user
    end    
  end

  def update
    if (@request = Request.find(params[:id])) && signed_in? && @request.helper.to_s == params[:user_id] && @request.helpee == current_user.id
      @request.update_attribute(:completed, true)
      @helper = User.find(params[:user_id])
      @review = Review.new(authorID: current_user.id, author: current_user.name)
      @helper.reviews.push(@review)
      @review.save(validate: false)
      @request.update_attribute(:review, @review.id)
      redirect_to user_request_path(@helper,@request)
    else
      redirect_to user_path(params[:user_id])
    end
  end

  def index
  end

  def show
    if ((@request = Request.find(params[:id])) && signed_in? && @request.helper.to_s == params[:user_id] && @request.helpee == current_user.id)
      @helper = User.find(params[:user_id])
      @helpee = current_user
      if (@request.completed)
        @review = Review.find(@request.review)
      else
      end
    else
      redirect_to user_path(params[:user_id])
    end
  end

  def create
    if signed_in?
      @helpee = current_user
      @helper = User.find(params[:user_id])
      @request = Request.create!(helper: @helper.id, helpee: @helpee.id, completed: false)
      @helpee.requests.push(@request)
      @helper.requests.push(@request)
      redirect_to user_request_path(@helper,@request)
    else
      signed_in_user
    end
  end



  private

    def check_provider_status
      if @helpee.is_provider || !@helper.is_provider
        render 'error'
      else
      end
    end


end
