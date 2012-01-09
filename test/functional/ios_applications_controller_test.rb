require 'test_helper'

class IosApplicationsControllerTest < ActionController::TestCase
  setup do
    @ios_application = ios_applications(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ios_applications)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ios_application" do
    assert_difference('IosApplication.count') do
      post :create, :ios_application => @ios_application.attributes
    end

    assert_redirected_to ios_application_path(assigns(:ios_application))
  end

  test "should show ios_application" do
    get :show, :id => @ios_application.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @ios_application.to_param
    assert_response :success
  end

  test "should update ios_application" do
    put :update, :id => @ios_application.to_param, :ios_application => @ios_application.attributes
    assert_redirected_to ios_application_path(assigns(:ios_application))
  end

  test "should destroy ios_application" do
    assert_difference('IosApplication.count', -1) do
      delete :destroy, :id => @ios_application.to_param
    end

    assert_redirected_to ios_applications_path
  end
end
