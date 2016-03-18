require 'test_helper'

class QuestionControllerTest < ActionController::TestCase
  test "should get make" do
    get :make
    assert_response :success
  end

  test "should get list" do
    get :list
    assert_response :success
  end

end
