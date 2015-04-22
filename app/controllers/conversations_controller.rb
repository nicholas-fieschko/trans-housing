class ConversationsController < ApplicationController

	# Show user's inbox, ordered by most recently updated
	def index
		@user = current_user
		@inbox = Conversation.where(:user_ids => @user.id)
	end

	# Gather form info for the new conversation
	def new
		@user = User.find(params[:user_id])
		@conversation = Conversation.new(:user_ids => [@user.id, current_user.id])
		@user.save
		current_user.save
	end

	# Create that new conversation, persist, and redirect to inbox
	def create
		@user = User.find(params[:user_id])
		@user.save
		redirect_to user_conversations_path
	end

	# Display a particular conversation (fully expanded)
	def show

	end

	# Add a message to a 
	def update

	end

	# Delete a conversation (no individual message deletion)
	def destroy

	end

	# Rails 4 strong params stuff
	private
	def conversation_params
		params.require(:conversation).permit(:messages, :subject)
	end

end
