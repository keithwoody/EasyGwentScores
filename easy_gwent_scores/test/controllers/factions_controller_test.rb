require 'test_helper'

class FactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @faction = factions(:one)
  end

  test "should get index" do
    get factions_url, as: :json
    assert_response :success
  end

  test "should show faction" do
    get faction_url(@faction), as: :json
    assert_response :success
  end

end
