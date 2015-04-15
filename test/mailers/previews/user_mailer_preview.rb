# Preview @ http://localhost:3000/rails/mailers/user_mailer/<method>
class UserMailerPreview < ActionMailer::Preview
  def sample_mail_preview
		UserMailer.sample_email(User.first)
  end
end
