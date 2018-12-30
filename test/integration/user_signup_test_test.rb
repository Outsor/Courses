require 'test_helper'

class UserSignupTestTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "invalid signup information" do
    get new_user_path
    assert_no_difference 'User.count' do
      post users_path(params: { user: { name:  "",
                                        email: "user@invalid",
                                        password:              "foo",
                                        password_confirmation: "bar" } })
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "success signup" do
    get new_user_path
    assert_response 200
    assert_difference 'User.count',+1 do
      post users_path(params: { user: { name:  "123",
                                        email: "chengzijun18@iie.ac.cn",
                                        password:"123123123",
                                        password_confirmation: "123123123" } })
    end
    reset_email = ActionMailer::Base.deliveries.last
    assert_equal "选课系统激活账号", reset_email.subject
    assert_equal  "chengzijun18@iie.ac.cn",reset_email.to[0]
    assert_match(//, reset_email.body.to_s)
  end
end
