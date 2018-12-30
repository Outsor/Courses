require 'test_helper'

class CoursesControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user    = users(:czj)
    @user2   = users(:michael)
    @teacher = users(:teacherluo)
    @course1 = courses(:one)
    @course2 = courses(:two)
    @course3 = courses(:three)

  end

  test "should not get courses when not logged in" do
    get courses_path
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should not get new when not logged in" do
    get new_course_path
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should not get select_course when not logged in" do
    get select_path(@user)
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should not get quit_course when not logged in" do
    get quit_course_path(@user)
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  # test "should not get semester when not logged in" do
  #   get semester_course_path(@user)
  #   assert_not flash.empty?
  #   assert_redirected_to root_url
  # end
  #
  # # test "should get new by teacher not student" do
  # #   log_in_as(@user)
  # #   get new_course_path
  # #   assert_not flash.empty?
  # #   assert_redirected_to root_url
  # #   delete sessions_logout_path
  # #   log_in_as(@teacher)
  # #   get new_course_path
  # #   assert_template "courses/new"
  # #   assert_select "h3","新课程"
  # # end
  #
  # test "should get semester by teacher not student" do
  #   log_in_as(@user)
  #   get semester_course_path(@user)
  #   assert_not flash.empty?
  #   assert_redirected_to root_url
  #   delete sessions_logout_path
  #   log_in_as(@teacher)
  #   get semester_course_path(@teacher)
  #   assert_template "courses/semester"
  # end
  #
  # test "should not get selected when not logged in" do
  #   get selected_course_path(@course2)
  #   assert_not flash.empty?
  #   assert_redirected_to root_url
  # end
  #
  # test "should get selected by teacher not student" do
  #   log_in_as(@user)
  #   get selected_course_path(@user)
  #   assert_not flash.empty?
  #   assert_redirected_to root_url
  #   delete sessions_logout_path
  #   log_in_as(@teacher)
  #   get selected_course_path(@course2)
  #   assert_template "courses/selected"
  # end
  #
  # test "should not get chart when not logged in" do
  #   get chart_course_path(@course2)
  #   assert_not flash.empty?
  #   assert_redirected_to root_url
  # end
  #
  # test "should get chart by teacher not student" do
  #   log_in_as(@user)
  #   get chart_course_path(@course2)
  #   assert_not flash.empty?
  #   assert_redirected_to root_url
  #   delete sessions_logout_path
  #   log_in_as(@teacher)
  #   get chart_course_path(@course2)
  #   assert_template "courses/chart"
  # end
end