class ExchangesController < ApplicationController

  def new
    get_provider_seeker
    if current_user_type == 'provider'
      render 'new_for_provider'
    else
      render 'new_for_seeker'
    end
  end


  def update
    signed_in_user
    @exchange = Exchange.find(params[:id])

    if (@exchange.seeker_id == current_user.id || @exchange.provider_id == current_user.id)

      if params[:accept]
        @exchange.update_attribute(:"#{current_user_type}_accept_exchange", true)
      elsif params[:confirm]
        @exchange.update_attribute(:"#{current_user_type}_confirm_interaction", true)
      end

      if !@exchange.completed && @exchange.seeker_confirm_interaction && @exchange.provider_confirm_interaction
        @exchange.set_complete
        create_new_review(@exchange.seeker,@exchange.provider)
        create_new_review(@exchange.provider,@exchange.seeker)
      end

      redirect_to user_exchange_path(params[:user_id],@exchange)

    else
      not_a_participant
    end
  end


  def show
    signed_in_user
    @exchange = Exchange.find(params[:id])
    @provider = @exchange.provider
    @seeker = @exchange.seeker
    if @exchange.seeker_id == current_user.id
      render 'show_for_seeker'
    elsif @exchange.provider_id == current_user.id
      render 'show_for_provider'
    else
      not_a_participant
    end
  end


  def create
    get_provider_seeker 
    @exchange = Exchange.create!(provider_id: @provider.id, seeker_id: @seeker.id)
    @exchange.update_attribute(:"#{current_user_type}_accept_exchange", true)
    @seeker.exchanges.push(@exchange)
    @provider.exchanges.push(@exchange)
    redirect_to user_exchange_path(params[:user_id],@exchange)
  end



  private

    def get_provider_seeker
      signed_in_user
      @user = User.find(params[:user_id])
      if current_user.provider? && @user.seeker?
        @provider = current_user
        @seeker = @user
      elsif current_user.seeker? && @user.provider?
        @seeker = current_user
        @provider = @user
      else
        render 'error'
      end
    end

    def current_user_type
      if current_user.provider? then 'provider' else 'seeker' end
    end

    def not_a_participant
      flash[:warning] = "Sorry only participants can see this page"
      redirect_to user_path(params[:user_id])
    end

    def create_new_review(reviewer,recipient)
        new_review = Review.new(reviewer_id: reviewer.id, recipient_id: recipient.id)
        recipient.reviews.push(new_review)
        new_review.save(validate: false)
        @exchange.update_attribute(:"#{reviewer.user_type}_review_for_#{recipient.user_type}_id", new_review.id)
        #Notifier.new_review(reviewer,recipient,new_review).deliver
    end


end
