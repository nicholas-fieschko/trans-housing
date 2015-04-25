class RequestsController < ApplicationController
  def new
    if get_provider_seeker == 'provider'
      render 'new_for_provider'
    else
      render 'new_for_seeker'
    end
  end

  def update
    if (@request = Request.find(params[:id])) && signed_in? && (@request.seeker == current_user.id || @request.provider == current_user.id)
      @provider = User.find(@request.provider)
      @seeker = User.find(@request.seeker)
      @request.update_attribute(:completed, true)

      @seeker_review_for_provider = Review.new(authorID: @seeker.id, author: @seeker.name)
      @provider.reviews.push(@seeker_review_for_provider)
      @seeker_review_for_provider.save(validate: false)
      @request.update_attribute(:seeker_review_for_provider, @seeker_review_for_provider.id)
      Notifier.new_review(@seeker,@provider,@seeker_review_for_provider).deliver

      @provider_review_for_seeker = Review.new(authorID: @provider.id, author: @provider.name)
      @seeker.reviews.push(@provider_review_for_seeker)
      @provider_review_for_seeker.save(validate: false)
      @request.update_attribute(:provider_review_for_seeker, @provider_review_for_seeker.id)
      Notifier.new_review(@provider,@seeker,@provider_review_for_seeker).deliver

      redirect_to user_request_path(params[:user_id],@request)
    else
      redirect_to user_path(params[:user_id])
    end
  end

  def index
  end

  def show
    if (@request = Request.find(params[:id])) && signed_in?
      @provider = User.find(@request.provider)
      @seeker = User.find(@request.seeker)
      if @request.completed
        @seeker_review_for_provider = Review.find(@request.seeker_review_for_provider)
        @provider_review_for_seeker = Review.find(@request.provider_review_for_seeker)
      end
      if @request.seeker == current_user.id
        render 'show_for_seeker'
      elsif @request.provider == current_user.id
        render 'show_for_provider'
      else
        redirect_to user_path(params[:user_id])
      end
    else
      redirect_to user_path(params[:user_id])
    end
  end

  def create
    get_provider_seeker 
    @request = Request.create!(provider: @provider.id, seeker: @seeker.id, confirmed: false, completed: false)
    @seeker.requests.push(@request)
    @provider.requests.push(@request)
    redirect_to user_request_path(params[:user_id],@request)
  end



  private

    def get_provider_seeker

      if signed_in?
        if current_user.is_provider && !User.find(params[:user_id]).is_provider
          @provider = current_user
          @seeker = User.find(params[:user_id])
          return 'provider'
        elsif !current_user.is_provider && User.find(params[:user_id]).is_provider
          @seeker = current_user
          @provider = User.find(params[:user_id])
          return 'seeker'
        else
          render 'error'
        end
      else
        signed_in_user
      end

    end


end
