# Preview all emails at http://localhost:3000/rails/mailers/welcome_mailer
class WelcomeMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/welcome_mailer/welcome
  def welcome
    WelcomeMailer.welcome(User.first || User.new(email_address: "mechanic@wheelhouse.cl"))
  end
end
