class ConversationsController < ApplicationController

	# Show user's inbox, ordered by most recently updated; where just finds
	# all conversations in which @user is in the user_ids
	def index
		@user = current_user
		@inbox = Conversation.where(:user_ids => @user.id)
	end

	# Gather form info for the new conversation; send the message to whatever
	# profile we are viewing--this will be in params as :user_id
	def new
		@receiver = User.find(params[:user_id])
		@conversation = Conversation.create(:user_ids => [@receiver.id, current_user.id])
		
		# Persist both users so that they have the conversation now
		@receiver.save
		current_user.save
	end

	# Create that new conversation, persist, and redirect to inbox
	def create
		@user = User.find(params[:user_id])
	
		@user.save
		current_user.save
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
