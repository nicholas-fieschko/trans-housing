# Per gotealeaf, Rails 4.2.1 supports preview fx
class UserMailer < ActionMailer::Base
  default from: 'noreply@transhousing.com'

	def welcome_email(user)
		@user = user
    mail(to: @user.email, subject: 'Welcome to TransHousing')
	end

	# For use in test/mailers/preview
	def sample_email(user)
		@user = user
		mail(to: @user.email, subject: 'Sample Email')
	end

	# Add all the other types of email we will need to send

end
