class NotifyMailer < ApplicationMailer
  default from: 'notifications@favtune.herokuapp.com'

  def notify_mail(user)
    @user = user
    @url  = 'https://favtune.herokuapp.com'
    mail to: "#{@user.email}", subject: "Favtune Sign Up Done!"
  end
end
