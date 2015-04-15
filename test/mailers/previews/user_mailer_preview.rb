# Preview @ http://localhost:3000/rails/mailers/user_mailer/<method>
class UserMailerPreview < ActionMailer::Preview
  def sample_preview
		UserMailer.sample_mailer(User.first)
		debug()
  end
end
