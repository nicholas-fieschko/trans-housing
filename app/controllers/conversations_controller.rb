class ConversationsController < ApplicationController

	# Show user's inbox, ordered by most recently updated; where just finds
	# all conversations in which @user is in the user_ids
	def index
		@user = current_user
		@inbox = Conversation.where(:user_ids => @user.id, )

	end

	# Gather form info for the new conversation; send the message to whatever
	# profile we are viewing--this will be in params as :user_id
	def new
		@user     = current_user
		@receiver = User.find(params[:user_id])

		@conversation = Conversation.create#(user_ids: [@user.id, @receiver.id])
		@conversation.messages.push(Message.new)#(sender: current_user.id, receiver: @receiver.id))
	end

	# Create that new conversation, persist, and redirect to inbox
	def create
		@user     = current_user
		@receiver = User.find(params[:user_id])

		@conversation = Conversation.new(
			user_ids: [@user.id, @receiver.id],
			subject: params[:conversation][:subject]
		)
		@message = Message.new(
			sender: @user.id,
			receiver: @receiver.id,
			text: params[:message][:text]
		)
		
		@conversation.messages.push(@message)
		@message.save
		@conversation.save

		redirect_to user_conversations_path
	end

	# Display a particular conversation (fully expanded)
	def show
		@thread = Conversation.find(params[:id])
	end

	# Add a message to a thread (display this option in show)
	def update
		@thread   = Conversation.find(params[:id])
		@sender   = @thread.messages.first.sender
		@receiver = @thread.messages.first.receiver
	
		@message = Message.new(
			sender:   @sender,
			receiver: @receiver,
			text:     params[:message][:text]
		)
		
		@thread.messages.push(@message)
		@thread.save

		redirect_to user_conversation_path(id: @thread.id)
	end

	# Delete a conversation (no individual message deletion)
	def destroy
		# - Find way to only delete for the current user
		# - Using destroy vs. delete to also delete child messages
		@thread = Conversation.find(params[:id])		

		# Call Model method to delete current user's owner link
		@thread.remove_user(current_user)

		# Go back to inbox!
		redirect_to user_conversations_path
	end

	# Rails 4 Strong Params
	private
		# Allow access to message model attributes within conversation
    def conversation_params
      params.require(:conversation).permit(
        :subject,
        message_attributes: [:sender, :receiver, :text],
      )
    end

end
