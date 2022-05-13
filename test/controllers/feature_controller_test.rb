require 'test_helper'

class FeatureControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get feature_new_url
    assert_response :success
  end

  test "should get create" do
    get feature_create_url
    assert_response :success
  end

  test "should get edit" do
    get feature_edit_url
    assert_response :success
  end

  test "should get update" do
    get feature_update_url
    assert_response :success
  end

  test "should get show" do
    get feature_show_url
    assert_response :success
  end

  test "should get destroy" do
    get feature_destroy_url
    assert_response :success
  end

end
