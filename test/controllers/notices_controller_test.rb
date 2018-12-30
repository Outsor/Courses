require 'test_helper'

class NoticesControllerTest < ActionController::TestCase
  setup do
    @notice = notices(:one)
  end


  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create notice" do
    assert_difference('Notice.count') do
      post :create, notice: { content: @notice.content, name: @notice.name }
    end

    assert_redirected_to notice_path(assigns(:notice))
  end

  test "should show notice" do
    get :show, id: @notice
    assert_response :success
  end



end
