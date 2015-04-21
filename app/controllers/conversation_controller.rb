class ConversationController < ApplicationController

	def index
		@convo = Conversation.all.to_a
	end

end
