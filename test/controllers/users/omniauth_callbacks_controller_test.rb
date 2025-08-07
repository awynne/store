require "test_helper"

class Users::OmniauthCallbacksControllerTest < ActionDispatch::IntegrationTest

  test "controller has google oauth2 method" do
    controller = Users::OmniauthCallbacksController.new
    assert_respond_to controller, :google_oauth2
  end

  test "controller has github method" do
    controller = Users::OmniauthCallbacksController.new
    assert_respond_to controller, :github
  end

  test "controller has failure method" do
    controller = Users::OmniauthCallbacksController.new
    assert_respond_to controller, :failure
  end
end
