require "test_helper"

class WelcomeMailerTest < ActionMailer::TestCase
  test "welcome email has HTML and text parts and links to sign in" do
    user = User.create!(
      email_address: "welcome@wheelhouse.cl",
      password: "AsecurePassword26!",
      password_confirmation: "AsecurePassword26!"
    )
    email = WelcomeMailer.welcome(user)

    assert_equal "Welcome to Wheelhouse", email.subject
    assert_equal [ user.email_address ], email.to
    assert_match "Wheelhouse", email.html_part.body.decoded
    assert_match "Wheelhouse", email.text_part.body.decoded
    assert_includes email.html_part.body.decoded, "http://example.com/session/new"
    assert_includes email.text_part.body.decoded, "http://example.com/session/new"
  end
end
