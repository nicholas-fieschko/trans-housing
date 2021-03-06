class ConversationsController < ApplicationController
  
  # Show user's inbox, ordered by most recently updated; where just finds
  # all conversations in which @user is in the user_ids
  def index
    @user  = current_user
    @inbox = Conversation.where(:user_ids => @user.id)
  end
  
  # Gather form info for the new conversation; send the message to whatever
  # profile we are viewing--this will be in params as :user_id
  def new
    @sender   = current_user
    @receiver = User.find(params[:user_id])
    
    # These are redundant . . . 
    @conversation = Conversation.create     #(user_ids: [@user.id, @receiver.id])
    @conversation.messages.push(Message.new)#(sender: current_user.id, receiver: @receiver.id))
  end
  
  # Create that new conversation, persist, and redirect to inbox
  def create
    @sender   = current_user
    @receiver = User.find(params[:user_id])
    
    @conversation = Conversation.new(
                                     user_ids: [@sender.id, @receiver.id],
                                     readers: [@sender.id],
                                     subject: params[:conversation][:subject]
                                     )
    @conversation.owners = @conversation.user_ids.dup
    
    @message = Message.new(
                           sender: @sender.id,
                           text: params[:message][:text]
                           )
    
    # Add the message and then persist; callback will set owners
    @conversation.messages.push(@message)
    @message.save
    @conversation.save
    
    # Check preferences and then send copies to email and SMS as required
    send_copies(@sender, @receiver, @message)
    
    # Go back to inbox!
    redirect_to user_conversations_path
  end
  
  # Display a particular conversation; mark that the user has now 'read'
  # the conversation by adding them to readers array
  def show
    @user   = current_user
    @thread = Conversation.find(params[:id])
    # Don't push ID if it's already in there
    if @thread.readers.exclude? @user.id
      @thread.readers.push(@user.id)
    end
    @thread.save
  end
  
  # Once the message is added, send email and text copies as required
  # => MUST call .deliver!!
  def send_copies(sender, receiver, message)
    if sender.receives_message_notifs_by_email?
      Notifier.new_message(sender, receiver, message).deliver
    end
    if sender.receives_message_notifs_by_text?
      Notifier.new_sms(sender, receiver, message).deliver
    end
  end
  
  # Add a message to a thread (display this option in show)
  def update
    @sender   = current_user
    @receiver = User.find(params[:user_id])
    @thread   = Conversation.find(params[:id])
    
    @message = Message.new(
                           sender:   @sender.id,
                           text:     params[:message][:text]
                           )
    
    # Reset the unread list; only the sender will have read the msg
    @thread.readers = [@sender.id]
    
    # If the receiver had deleted ownership of the thread, undelete
    if @thread.owners.exclude? @receiver.id
      @thread.owners.push(@receiver.id)
    end
    
    # Persist the message
    @thread.messages.push(@message)
    @thread.save
    
    # Trigger some emails/SMS
    send_copies(@sender, @receiver, @message)
    
    # Return to the updated conversation
    redirect_to user_conversation_path(id: @thread.id)
  end
  
  # Delete a conversation (no individual message deletion)
  def destroy
    @thread = Conversation.find(params[:id])		
    
    # Delete current user's owner link; callback will hard delete
    # if it was the last link.
    @thread.remove_owner(current_user)
    
    #@thread.destroy!
    
    # Go back to inbox!
    redirect_to user_conversations_path
  end
  
  # Rails 4 Strong Params
  private
  # Allow access to message model attributes within conversation
  def conversation_params
    params.require(:conversation).permit(
                                         :subject,
                                         :owners,
                                         :readers,
                                         message_attributes: [:sender, :text],
                                         )
  end
end
