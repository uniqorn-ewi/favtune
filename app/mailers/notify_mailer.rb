class NotifyMailer < ApplicationMailer
  default from: 'notifications@favtune.herokuapp.com'

  def notify_mail(user)
    @user = user
    mail to: "#{@user.email}", subject: "Account activation"
  end
end
