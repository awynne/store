require "application_system_test_case"

class AuthenticationTest < ApplicationSystemTestCase
  test "user can sign up with email and password" do
    visit root_path
    click_on "Sign up"

    fill_in "Email", with: "newuser@example.com"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    click_on "Sign up"

    assert_text "Welcome! You have signed up successfully."
    assert_text "Welcome, newuser!"
    assert_text "Sign out"
  end

  test "user can sign in with email and password" do
    User.create!(email: "existing@example.com", password: "password123")

    visit root_path
    click_on "Sign in"

    fill_in "Email", with: "existing@example.com"
    fill_in "Password", with: "password123"
    click_on "Log in"

    assert_text "Signed in successfully."
    assert_text "Welcome, existing!"
    assert_text "Sign out"
  end

  test "user can sign out" do
    user = User.create!(email: "user@example.com", password: "password123")
    sign_in user

    visit root_path
    click_on "Sign out"

    assert_text "Signed out successfully."
    assert_text "Sign up"
    assert_text "Sign in"
  end

  test "sign in page shows social login buttons" do
    visit new_user_session_path

    assert_text "Log in"
    assert_link "Sign in with Google"
    assert_link "Sign in with GitHub"
    assert_text "or"
  end

  test "sign up page shows social login buttons" do
    visit new_user_registration_path

    assert_text "Sign up"
    assert_link "Sign up with Google"
    assert_link "Sign up with GitHub"
    assert_text "or"
  end

  test "navigation shows correct links for signed out user" do
    visit root_path

    within "header" do
      assert_link "WebStore"
      assert_link "Sign up"
      assert_link "Sign in"
      assert_no_text "Sign out"
    end
  end

  test "navigation shows correct links for signed in user" do
    user = User.create!(email: "user@example.com", password: "password123", name: "John Doe")
    sign_in user

    visit root_path

    within "header" do
      assert_link "WebStore"
      assert_text "Welcome, John Doe!"
      assert_link "Sign out"
      assert_no_link "Sign up"
      assert_no_link "Sign in"
    end
  end

  test "user display name shows email prefix when name is blank" do
    user = User.create!(email: "john.doe@example.com", password: "password123")
    sign_in user

    visit root_path

    within "header" do
      assert_text "Welcome, john.doe!"
    end
  end

  private

  def sign_in(user)
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Log in"
  end
end
