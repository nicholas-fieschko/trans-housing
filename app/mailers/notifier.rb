class Notifier < ApplicationMailer

	# - Sends an email to the user upon signup (set in users_controller)
	# - In Fabricator, all user emails set to 'stephen.krewson@gmail.com'
	# - Text of email in views/welcome.text.haml (no html yet)
	def welcome(user)
		@user = user
		mail(to: "stephen.krewson@gmail.com", subject: "[TransHousing] Welcome!")
	end

	# - By default, users get sent an email notification on receiving message
	# - Eventually, we'll have more formal notion of an 'offer'.
	# - Need to have opt-out logic.
	def new_message(to, from)
		@to   = to
		@from = from
		mail(
				 to: @to.contact.email,
				 subject: "[TransHousing] New message from #{@from.name}"
				)
	end

	# - We will need more of these!

end
