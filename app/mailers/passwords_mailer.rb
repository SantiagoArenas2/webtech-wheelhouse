class PasswordsMailer < ApplicationMailer
  def reset(user)
    @user = user
    mail subject: "Wheelhouse password reset", to: user.email_address
  end
end
