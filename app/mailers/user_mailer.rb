class UserMailer < ApplicationMailer

	# Need to set up the mail server
  default from: 'noreply@transhousing.com'

  # I need to also do a captcha!

	# At what other points will users need a non-changing email?
	def welcome_email(user)
		@user = user
    mail(to: @user.email, subject: 'Welcome to TransHousing')
	end

	# Notifications for messages (set in preferences)
	def notify_email(user, message)
  end


end
