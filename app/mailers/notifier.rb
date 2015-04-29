require 'twilio-ruby'

class Notifier < ApplicationMailer

	# - Sends an email to the user upon signup (set in users_controller)
	# - In Fabricator, all user emails set to 'stephen.krewson@gmail.com'
	# - Text of email in views/welcome.text.haml (no html yet)
	def welcome(receiver)
		@receiver = user
		mail(
			to: receiver.contact.email,
			subject: "[TransHousing] Welcome!"
		)
	end

	# - By default, users get sent an email notification on receiving message
	# - Eventually, we'll have more formal notion of an 'offer'.
	# - Need to have opt-out logic.
	def new_message(sender, receiver, message)
		@sender   = sender
		@receiver = receiver
		@message  = message
		@thread   = message.conversation_id
		mail(
			to: 	 receiver.contact.email,
			subject: "[TransHousing] New message from #{sender.name}",
			text:    message.text
		)
	end

	def new_review(sender, receiver, review)
		@sender   = sender
		@receiver = receiver
		@review   = review
		mail(
			to:      "stephen.krewson@gmail.com", 
			subject: "[TransHousing] Please leave a review for #{receiver.name}",
		)
	end

	def new_sms(sender, receiver, message)
		@sender   = sender
		@receiver = receiver
		@message  = message
		@thread   = message.conversation_id

		# Link sender with rotp counter
		#secret_key = ROTP::Base32.random_base32
		#hotp = ROTP::HOTP.new(secret_key)

		# Append to message body
		#ret_code = @message
		#ret_code << "Reply by including this code: "
		#ret_code << hotp.at(0)

		ret_link = user_conversation_path(
			user_id: @receiver.id.to_s,
			id: @thread.to_s
		).prepend(ENV['heroku_path'])

		ret_link.prepend("#{message.text} | Reply: ")
		ret_link.prepend("From #{sender.name} | ")

		@client = Twilio::REST::Client.new
		@client.messages.create(
			from: ENV['twilio_num'],
			to:   @receiver.contact.phone,
			body: ret_link
		)
	end

end
