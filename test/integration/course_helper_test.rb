require 'test_helper'
include CourseHelper
include SessionsHelper
class CourseHelperTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:michael)
    @user2 = users(:czj2)
    @teacher = users(:teacherluo)
    @course1 = courses(:one)
    @course2 = courses(:two)
    @course3 = courses(:three)
    @course4 = courses(:course4)
    @course6 = courses(:course6)
  end

  test "not over number in course1" do
    assert_not is_over_number?(@course1)
  end

  test "over number in course1" do
    assert is_over_number?(@course3)
  end

  test "czj2 exit the wanted course" do
    log_in_as(@user2)
    assert is_exit_course?(@course2.id)
  end

  test "czj2 not exit the wanted course" do
    log_in_as(@user2)
    assert_not is_exit_course?(@course1.id)
  end

  test "time conflict course2 and course3 in czj2" do
    log_in_as(@user2)
    assert is_time_conflict?(@course3)
  end

  test "no time conflict course2 and course4 in czj2" do
    log_in_as(@user2)
    assert is_time_conflict?(@course4)
  end

  test "no week_time conflict course5 and course6 in czj2" do
    log_in_as(@user2)
    assert is_time_conflict?(@course6)
  end


  test "in select course time for student" do
    assert is_open_student?
  end

end
