require "test_helper"

class UserAdminTest < ActiveSupport::TestCase
  test "admin user should be admin" do
    admin_user = users(:admin)
    assert admin_user.admin?
    assert admin_user.local_account?
  end

  test "regular user should not be admin" do
    regular_user = users(:regular)
    assert_not regular_user.admin?
    assert regular_user.local_account?
  end

  test "oauth user should not be admin" do
    oauth_user = users(:oauth_user)
    assert_not oauth_user.admin?
    assert_not oauth_user.local_account?
  end

  test "local account should be identified correctly" do
    local_user = User.new(email: "local@example.com", provider: nil, uid: nil)
    assert local_user.local_account?
  end

  test "oauth account should be identified correctly" do
    oauth_user = User.new(email: "oauth@example.com", provider: "google_oauth2", uid: "123")
    assert_not oauth_user.local_account?
  end

  test "cannot create admin user with oauth provider" do
    user = User.new(
      email: "test@example.com",
      password: "password123",
      name: "Test User",
      admin: true,
      provider: "google_oauth2",
      uid: "123456"
    )

    assert_not user.valid?
    assert_includes user.errors[:admin], "accounts must be local (not OAuth)"
  end

  test "can create admin user without oauth provider" do
    user = User.new(
      email: "admin@example.com",
      password: "password123",
      admin: true,
      provider: nil,
      uid: nil
    )

    assert user.valid?
  end

  test "can create regular user with oauth provider" do
    user = User.new(
      email: "new_oauth@example.com",
      password: "password123",
      name: "OAuth User",
      admin: false,
      provider: "google_oauth2",
      uid: "123456"
    )

    assert user.valid?
  end

  test "can create regular user without oauth provider" do
    user = User.new(
      email: "regular@example.com",
      password: "password123",
      admin: false,
      provider: nil,
      uid: nil
    )

    assert user.valid?
  end

  test "updating existing oauth user to admin should fail" do
    oauth_user = users(:oauth_user)
    oauth_user.admin = true

    assert_not oauth_user.valid?
    assert_includes oauth_user.errors[:admin], "accounts must be local (not OAuth)"
  end

  test "updating existing local user to admin should succeed" do
    regular_user = users(:regular)
    regular_user.admin = true

    assert regular_user.valid?
  end

  test "admin defaults to false" do
    user = User.new(email: "test@example.com")
    assert_equal false, user.admin
    assert_not user.admin?
  end
end
