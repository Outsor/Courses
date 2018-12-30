require 'test_helper'

class SessionsTestTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:czj)
    @user2 = users(:michael)
    @user3=users(:czj2)
  end

  test "account reset" do
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      post forgot_url, email: {:email => @user.email}
    end
    reset_email = ActionMailer::Base.deliveries.last
    assert_equal "选课系统重置密码", reset_email.subject
    assert_equal @user.email, reset_email.to[0]
    assert_match(//, reset_email.body.to_s)
  end
  test "account reset unsuccess" do
    assert_difference 'ActionMailer::Base.deliveries.size', +0 do
      post forgot_url, email: {:email => @user.email+'123'}
    end

    assert_difference 'ActionMailer::Base.deliveries.size', +0 do
      post forgot_url, email: {:email => nil}
    end
  end
  test "account active" do
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      post active_url, email: {:email => @user.email}
    end
    active_email = ActionMailer::Base.deliveries.last

    assert_equal "选课系统激活账号", active_email.subject
    assert_equal @user.email, active_email.to[0]
    assert_match(//, active_email.body.to_s)
  end

  test "password reset" do
    get reset_path(email: @user.email,token: @user.token)
    assert flash.empty?
  end

  test "password reset unsuccess" do
    get reset_path(email: @user2.email,token: @user.token)
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "password reset act unsuccess" do
    post reset_path(params: {session: {email: '123'+@user.email, password: 'password'}})
    assert_not flash.empty?
    #assert_equal "unknown error",flash.to_param
    assert_redirected_to root_url
  end
  test "password reset act success" do
    post reset_path(params: {session: {email: @user.email, password: 'password'}})
    assert_not flash.empty?
    #assert_equal "123",flash
    assert_redirected_to root_url
  end

  test "active unsuccess" do
    get users_url(params: {email:'123'+@user.email,token:@user.token})
    assert_not flash.empty?
    #assert_equal "123",flash
    assert_redirected_to root_url

    get users_url(params: {email:@user3.email,token:@user3.token})
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  test "active success" do
    get users_url(params: {email:@user.email,token:@user.token})
    assert_not flash.empty?
    assert_redirected_to root_url
  end
end
