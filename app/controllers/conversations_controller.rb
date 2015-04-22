class ConversationsController < ApplicationController

	# Show user's inbox, ordered by most recently updated
	def index
	end

	# Gather form info for the new conversation
	def new
		@user = User.find(params[:user_id])
		@conversation = Conversation.new
	end

	# Create that new conversation
	def create
		@user = User.find(params[:user_id])
		@user.save
	end

	# Display a particular conversation (fully expanded)
	def show

	end

	# Add a message to a 
	def update()

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
