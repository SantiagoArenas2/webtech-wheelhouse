require "test_helper"

class AuthenticationTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email_address: "staff@wheelhouse.cl",
      password: "AsecurePassword26!",
      password_confirmation: "AsecurePassword26!"
    )
  end

  test "visitors can view services but are redirected from closed pages" do
    get services_url
    assert_response :success
    assert_select "nav a", text: "Services"
    assert_select "nav a", text: "Sign in"
    [ "Home", "Customers", "Bikes", "Repairs", "Staff", "Visit the workshop", "About" ].each do |label|
      assert_select "nav a", text: label, count: 0
    end
    assert_select "a", text: "New service", count: 0

    price_list = PriceList.create!(year: 2026, effective_from: Date.new(2026, 1, 1))
    service = ServiceCatalogueItem.create!(price_list: price_list, name: "Safety check", list_price: 15)
    get service_url(service)
    assert_response :success
    assert_select "h2", text: "Repairs that used this service", count: 0
    assert_select "a", text: "Edit", count: 0
    assert_select "button", text: "Delete", count: 0

    get customers_url
    assert_redirected_to new_session_url
  end

  test "sign in returns visitors to the page they requested" do
    get repairs_url
    assert_redirected_to new_session_url

    post session_url, params: {
      email_address: @user.email_address.upcase,
      password: "AsecurePassword26!"
    }

    assert_redirected_to repairs_url
    cookies = response.headers["Set-Cookie"].join("\n")
    assert_match(/httponly/i, cookies)
    assert_match(/samesite=lax/i, cookies)
  end

  test "sign out is a delete and closes the next request" do
    post session_url, params: {
      email_address: @user.email_address,
      password: "AsecurePassword26!"
    }
    delete session_url
    assert_redirected_to new_session_url

    get customers_url
    assert_redirected_to new_session_url
  end

  test "sign up ignores submitted role and staff member" do
    assert_enqueued_emails 1 do
      post users_url, params: {
        user: {
          email_address: "new-staff@wheelhouse.cl",
          password: "NewStaffPassword26!",
          password_confirmation: "NewStaffPassword26!",
          role: User.roles.fetch(:owner),
          staff_member_id: 1
        }
      }
    end

    new_user = User.find_by!(email_address: "new-staff@wheelhouse.cl")
    assert_equal User.roles.fetch(:mechanic), new_user.role
    assert_nil new_user.staff_member_id
    assert_redirected_to root_url
  end

  test "refused sign up keeps the email and clears password inputs" do
    post users_url, params: {
      user: {
        email_address: "short-password@wheelhouse.cl",
        password: "Short123!",
        password_confirmation: "Short123!"
      }
    }

    assert_response :unprocessable_entity
    assert_select "input[name='user[email_address]'][value='short-password@wheelhouse.cl']"
    assert_select "input[type='password'][value]", false
    assert_select ".invalid-feedback", text: /minimum is 10 characters/
  end

  test "password reset email changes the password and invalidates its link" do
    perform_enqueued_jobs do
      post passwords_url, params: { email_address: @user.email_address.upcase }
    end

    assert_redirected_to new_session_url
    email = ActionMailer::Base.deliveries.last
    assert_equal "Wheelhouse password reset", email.subject
    assert_match "Wheelhouse", email.html_part.body.decoded
    assert_match "Wheelhouse", email.text_part.body.decoded

    reset_link = URI.parse(email.html_part.body.decoded[/href="([^"]+)"/, 1])
    assert_equal "example.com", reset_link.host
    get reset_link.request_uri
    assert_response :success

    token = reset_link.path.split("/")[2]
    put password_url(token), params: {
      password: "Short123!",
      password_confirmation: "Short123!"
    }
    assert_redirected_to edit_password_url(token)
    assert_match(/minimum is 10 characters/, flash[:alert])

    put password_url(token), params: {
      password: "ResetPassword26!",
      password_confirmation: "ResetPassword26!"
    }
    assert_redirected_to new_session_url
    assert @user.reload.authenticate("ResetPassword26!")

    get reset_link.request_uri
    assert_redirected_to new_password_url

    post session_url, params: {
      email_address: @user.email_address,
      password: "ResetPassword26!"
    }
    assert_redirected_to root_url
  end

  test "forgotten-password requests use the same response for unknown emails" do
    post passwords_url, params: { email_address: @user.email_address }
    known_email_notice = flash[:notice]

    post passwords_url, params: { email_address: "unknown@wheelhouse.cl" }

    assert_equal known_email_notice, flash[:notice]
    assert_redirected_to new_session_url
  end

  test "repair intake account comes from the session and is immutable on edit" do
    staff_member = StaffMember.create!(full_name: "Intake Staff", role: User.roles.fetch(:counter))
    customer = Customer.create!(full_name: "Repair Customer", phone: "555-0101")
    bike = Bike.create!(
      customer: customer,
      brand: "Trek",
      model: "Marlin",
      serial_number: "TEST-REPAIR-1"
    )
    another_user = User.create!(
      email_address: "other-staff@wheelhouse.cl",
      password: "AnotherPassword26!",
      password_confirmation: "AnotherPassword26!"
    )
    post session_url, params: {
      email_address: @user.email_address,
      password: "AsecurePassword26!"
    }

    post repairs_url, params: {
      repair_job: {
        bike_id: bike.id,
        received_by_staff_id: staff_member.id,
        status: "received",
        received_at: Time.current.iso8601,
        received_by_user_id: another_user.id
      }
    }
    repair = RepairJob.order(:id).last
    assert_equal @user, repair.received_by_user

    patch repair_url(repair), params: {
      repair_job: { received_by_user_id: another_user.id }
    }
    assert_equal @user, repair.reload.received_by_user

    get repair_url(repair)
    assert_response :success
    assert_select "dd", text: @user.email_address
  end
end
