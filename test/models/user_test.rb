require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "normalizes email addresses and treats case variants as duplicates" do
    user = User.create!(
      email_address: " Ana@Wheelhouse.cl ",
      password: "AsecurePassword26!",
      password_confirmation: "AsecurePassword26!"
    )

    assert_equal "ana@wheelhouse.cl", user.email_address
    duplicate = User.new(
      email_address: "ANA@WHEELHOUSE.CL",
      password: "AnotherPassword26!",
      password_confirmation: "AnotherPassword26!"
    )
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:email_address], "has already been taken"
  end

  test "defaults to the least-privileged role" do
    user = User.new

    assert_equal User.roles.fetch(:mechanic), user.role
  end

  test "rejects passwords shorter than ten characters" do
    user = User.new(
      email_address: "short-password@wheelhouse.cl",
      password: "Short123!",
      password_confirmation: "Short123!"
    )

    assert_not user.valid?
    assert_includes user.errors[:password], "is too short (minimum is 10 characters)"
  end

  test "database rejects email duplicates that differ only by case" do
    timestamps = { created_at: Time.current, updated_at: Time.current }
    User.insert_all!([
      { email_address: "unique-case@wheelhouse.cl", password_digest: "digest", **timestamps }
    ])

    assert_raises ActiveRecord::RecordNotUnique do
      User.insert_all!([
        { email_address: "UNIQUE-CASE@WHEELHOUSE.CL", password_digest: "digest", **timestamps }
      ])
    end
  end

  test "staff with an account cannot be destroyed" do
    staff_member = StaffMember.create!(full_name: "Account Holder", role: User.roles.fetch(:mechanic))
    User.create!(
      email_address: "account-holder@wheelhouse.cl",
      password: "AsecurePassword26!",
      password_confirmation: "AsecurePassword26!",
      staff_member: staff_member
    )

    assert_not staff_member.destroy
    assert staff_member.errors.any?
  end
end
