# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/pairbnb_welcome
  def pairbnb_welcome
    UserMailer.pairbnb_welcome
  end

end
