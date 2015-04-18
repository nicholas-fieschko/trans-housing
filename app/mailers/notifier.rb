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

end
