require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should create user with valid attributes" do
    user = User.new(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    assert user.valid?
    assert user.save
  end

  test "should require email" do
    user = User.new(password: "password123", password_confirmation: "password123")
    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "should require password" do
    user = User.new(email: "test@example.com")
    assert_not user.valid?
    assert_includes user.errors[:password], "can't be blank"
  end

  test "should require unique email" do
    User.create!(email: "test@example.com", password: "password123")
    user = User.new(email: "test@example.com", password: "password123")
    assert_not user.valid?
    assert_includes user.errors[:email], "has already been taken"
  end

  test "display_name should return name if present" do
    user = User.new(name: "John Doe", email: "john@example.com")
    assert_equal "John Doe", user.display_name
  end

  test "display_name should return email prefix if name blank" do
    user = User.new(email: "john.doe@example.com")
    assert_equal "john.doe", user.display_name
  end

  test "from_omniauth should create new user" do
    auth = Struct.new(:provider, :uid, :info).new(
      "google_oauth2",
      "123456789",
      Struct.new(:email, :name).new("oauth@example.com", "OAuth User")
    )

    user = User.from_omniauth(auth)
    assert user.persisted?
    assert_equal "oauth@example.com", user.email
    assert_equal "OAuth User", user.name
    assert_equal "google_oauth2", user.provider
    assert_equal "123456789", user.uid
  end

  test "from_omniauth should return existing user" do
    existing_user = User.create!(
      email: "existing@example.com",
      password: "password123"
    )

    auth = Struct.new(:provider, :uid, :info).new(
      "google_oauth2",
      "123456789",
      Struct.new(:email, :name).new("existing@example.com", "OAuth User")
    )

    user = User.from_omniauth(auth)
    assert_equal existing_user, user
  end


  test "should require name for omniauth users" do
    user = User.new(
      email: "oauth@example.com",
      password: "password123",
      provider: "google_oauth2",
      uid: "123456789"
    )
    assert_not user.valid?
    assert_includes user.errors[:name], "can't be blank"
  end
end
