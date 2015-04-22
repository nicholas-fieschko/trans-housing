class ConversationController < ApplicationController

	# Show user's inbox, ordered by most recently updated
	def index
		@convo = Conversation.all.to_a
	end

	# Gather form info for the new conversation
	def new
		@user = User.find(params[:user_id])
		@convo = Conversation.create
	end

	# Create that new conversation
	def create

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

end
