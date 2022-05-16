require 'test_helper'

class FeatureusagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @featureusage = featureusages(:one)
  end

  test "should get index" do
    get featureusages_url
    assert_response :success
  end

  test "should get new" do
    get new_featureusage_url
    assert_response :success
  end

  test "should create featureusage" do
    assert_difference('Featureusage.count') do
      post featureusages_url, params: { featureusage: { buyer_id: @featureusage.buyer_id, feature_id: @featureusage.feature_id, is_used: @featureusage.is_used, total_extra_units: @featureusage.total_extra_units } }
    end

    assert_redirected_to featureusage_url(Featureusage.last)
  end

  test "should show featureusage" do
    get featureusage_url(@featureusage)
    assert_response :success
  end

  test "should get edit" do
    get edit_featureusage_url(@featureusage)
    assert_response :success
  end

  test "should update featureusage" do
    patch featureusage_url(@featureusage), params: { featureusage: { buyer_id: @featureusage.buyer_id, feature_id: @featureusage.feature_id, is_used: @featureusage.is_used, total_extra_units: @featureusage.total_extra_units } }
    assert_redirected_to featureusage_url(@featureusage)
  end

  test "should destroy featureusage" do
    assert_difference('Featureusage.count', -1) do
      delete featureusage_url(@featureusage)
    end

    assert_redirected_to featureusages_url
  end
end
