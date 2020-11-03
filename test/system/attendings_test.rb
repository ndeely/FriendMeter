require "application_system_test_case"

class AttendingsTest < ApplicationSystemTestCase
  setup do
    @attending = attendings(:one)
  end

  test "visiting the index" do
    visit attendings_url
    assert_selector "h1", text: "Attendings"
  end

  test "creating a Attending" do
    visit attendings_url
    click_on "New Attending"

    fill_in "Event", with: @attending.event_id
    fill_in "User", with: @attending.user_id
    click_on "Create Attending"

    assert_text "Attending was successfully created"
    click_on "Back"
  end

  test "updating a Attending" do
    visit attendings_url
    click_on "Edit", match: :first

    fill_in "Event", with: @attending.event_id
    fill_in "User", with: @attending.user_id
    click_on "Update Attending"

    assert_text "Attending was successfully updated"
    click_on "Back"
  end

  test "destroying a Attending" do
    visit attendings_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Attending was successfully destroyed"
  end
end
