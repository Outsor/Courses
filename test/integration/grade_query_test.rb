require 'test_helper'

class GradeQueryTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    # @user  = users(:michael)
    @user2 = users(:czj2)
    
    @teacher6 = users(:teacher6)
    # @course1 = courses(:one)
    # @course2 = courses(:two)
    @course6 = courses(:course6)
    @grade4 = grade(:grade4)
    
  end

  test "query course index no login" do
    get grades_url
    assert_redirected_to root_path
    # assert_response 200
  end

  test "query course index login for student" do
    log_in_as(@user2)
    get grades_url
    assert_response 200
  end

  test "query course by department for student" do
  	log_in_as(@user2)
    get grades_url( params: {"year_term" => "2018-1"})
    assert_response 200
  end


  test "query course index login for teacher" do
    log_in_as(@teacher6)
    get grades_url( params: {"course_id" => @course6.id})
    assert_response 200
  end

  test "query course index no login for teacher" do
    get grades_url( params: {"course_id" => @course6.id})
    assert_redirected_to root_path
  end


  test "teacher update grades" do
    log_in_as(@teacher6)
    
    patch grade_url(@grade4, params: {"id" => @grade4.id, "grade" => {"grade"=>"55"} })
    assert_response :redirect
  end

end
