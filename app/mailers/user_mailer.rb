class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.pairbnb_welcome.subject
  #
  def pairbnb_welcome(user)
    @user = user
    @subject = "Welcome to PairBnB"
    mail(to: @user.email, subject: @subject)
  end
end
