require "application_system_test_case"

class FeatureusagesTest < ApplicationSystemTestCase
  setup do
    @featureusage = featureusages(:one)
  end

  test "visiting the index" do
    visit featureusages_url
    assert_selector "h1", text: "Featureusages"
  end

  test "creating a Featureusage" do
    visit featureusages_url
    click_on "New Featureusage"

    fill_in "Buyer", with: @featureusage.buyer_id
    fill_in "Feature", with: @featureusage.feature_id
    check "Is used" if @featureusage.is_used
    fill_in "Total extra units", with: @featureusage.total_extra_units
    click_on "Create Featureusage"

    assert_text "Featureusage was successfully created"
    click_on "Back"
  end

  test "updating a Featureusage" do
    visit featureusages_url
    click_on "Edit", match: :first

    fill_in "Buyer", with: @featureusage.buyer_id
    fill_in "Feature", with: @featureusage.feature_id
    check "Is used" if @featureusage.is_used
    fill_in "Total extra units", with: @featureusage.total_extra_units
    click_on "Update Featureusage"

    assert_text "Featureusage was successfully updated"
    click_on "Back"
  end

  test "destroying a Featureusage" do
    visit featureusages_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Featureusage was successfully destroyed"
  end
end
