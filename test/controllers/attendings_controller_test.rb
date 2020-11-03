require 'test_helper'

class AttendingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @attending = attendings(:one)
  end

  test "should get index" do
    get attendings_url
    assert_response :success
  end

  test "should get new" do
    get new_attending_url
    assert_response :success
  end

  test "should create attending" do
    assert_difference('Attending.count') do
      post attendings_url, params: { attending: { event_id: @attending.event_id, user_id: @attending.user_id } }
    end

    assert_redirected_to attending_url(Attending.last)
  end

  test "should show attending" do
    get attending_url(@attending)
    assert_response :success
  end

  test "should get edit" do
    get edit_attending_url(@attending)
    assert_response :success
  end

  test "should update attending" do
    patch attending_url(@attending), params: { attending: { event_id: @attending.event_id, user_id: @attending.user_id } }
    assert_redirected_to attending_url(@attending)
  end

  test "should destroy attending" do
    assert_difference('Attending.count', -1) do
      delete attending_url(@attending)
    end

    assert_redirected_to attendings_url
  end
end
