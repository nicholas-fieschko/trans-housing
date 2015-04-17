class Notifier < ApplicationMailer

def welcome(user)
  @user = user
  mail(to: @user.contact.email, subject: 'Welcome email') do |format|
    format.text
    # Uncomment the next line for multitype emails
    #format.html
  end
end

end
