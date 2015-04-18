class Notifier < ApplicationMailer

def welcome(user)
  @user = user
  mail(to: @user.contact.email, subject: 'Welcome email') do |format|
    format.text
    # Uncomment the next line for multitype emails
    #format.html
  end
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
