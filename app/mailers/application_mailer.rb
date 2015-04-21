class ApplicationMailer < ActionMailer::Base
  default sender: 'noreply@transhousing.com'
  layout 'mailer'
end
