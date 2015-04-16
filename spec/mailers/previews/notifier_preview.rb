# Preview all emails at http://localhost:3000/rails/mailers/notifier
class NotifierPreview < ActionMailer::Preview

  def welcome_preview
    Notifier.welcome(User.first)
  end

end
