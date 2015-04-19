# Sends email alerts and message copies to users
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

# Test method using MAILGUN; use default 'noreply' for :from and just dump
# them all to Stephen's email
def mailgun(user)
  @user = user
  mg_client = Mailgun::Client.new ENV['api_key']
  message_params = {
    :from    => 'noreply@transhousing.com',
    :to      => 'stephen.krewson@gmail.com',
    :subject => 'Greetings from TransHousing!',
    :text    => 'This is an email sent with Mailgun.',
  }
  # Now fire off the email!
  mg_client.send_message ENV['domain'], message_params
end

# Ruby wrapper for Twilio; send SMS copies of emails
# Keep everything text only
def twilio(user)
  @user = user
  account_sid = ENV['account_sid']
  auth_token  = ENV['auth_token']
  @client = Twilio::REST::Client.new(account_sid, auth_token)

  # Once client is talking to API, just send proof of concept text
  @client.messages.create(
    from: ENV['twilio_num'],
    to: '+15189283302',
    body: 'A test text from TransHousing!'
  )
  # Do twilio stuff here. Need to get convention over config stuff
  # working to DRY out the message (don't use :text)
end



end
