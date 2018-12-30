require 'test_helper'

class ChooseCoursesTestTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user2 =users(:czj2)
    @teacher = users(:teacherluo)
    @course1 = courses(:one)
    @course2 = courses(:two)
    @course3 = courses(:three)
    @course4 = courses(:course4)
    @course6 = courses(:course6)
    @course7 = courses(:course7)
    @teacher6 = users(:teacher6)
  end

  test "test choose course over number" do
    log_in_as(@user2)
    get select_path(params:{"id" => @course4.id})
    assert_not flash.empty?
  end

  test "test choose course time conflict" do
    log_in_as(@user2)
    get select_path(params:{"id" => @course3.id})
    assert_not flash.empty?
  end

  test "test choose course already exit" do
    log_in_as(@user2)
    get select_path(params:{"id" => @course6.id})
    assert_not flash.empty?
  end

  test "test choose course with no degree" do
    log_in_as(@user2)
    get select_path(params:{"id" => @course7.id})
    assert_not flash.empty?
  end

  test "test choose course with degree" do
    log_in_as(@user2)
    get select_path(params:{"id" => @course7.id, "degree" => true})
    assert_not flash.empty?
  end

  test "test student quit course " do
    log_in_as(@user2)
    get quit_course_path(@course2)
    assert_not flash.empty?
  end

  test "test student set_degree course on course2 " do
    log_in_as(@user2)
    get set_degree_course_path(@course6)
    assert_not flash.empty?
  end

  test "test student cancel_degree course on course2 " do
    log_in_as(@user2)
    get cancel_degree_course_path(@course6)
    assert_not flash.empty?
  end

  test "test teacher create new course " do
    log_in_as(@teacher6)
    get new_course_path
    assert_response 200
    # post courses_path(params:{"course" => @course7})
    
    post courses_path(
      params: 
      { 
        course:
        {
          course_code: "011D9039Z﹡",
          name: "course6",
          course_type: "其它",
          credit: "40/2.0",
          limit_num: "14",
          student_num: "1",
          course_week: "第11-20周",
          course_time: "周三(5-6)",
          class_room: "N306",
          teaching_type: "课堂讲授为主",
          exam_type: "大开卷",
          department: "数学学院",
          semester: "2018-1" 
        }
      }
      )
    assert_not flash.empty?
  end

  test "test teacher6 edit course6 " do
    log_in_as(@teacher6)
    get edit_course_path(@course6)
    assert_response 200

    patch course_url(@course6, params: 
      { 
        course:
        {
          course_code: "011D9039Z﹡",
          name: "course6",
          course_type: "其它",
          credit: "40/2.0",
          limit_num: "14",
          student_num: "1",
          course_week: "第11-20周",
          course_time: "周三(5-6)",
          class_room: "N306",
          teaching_type: "课堂讲授为主",
          exam_type: "大开卷",
          department: "数学学院",
          semester: "2018-1" 
        }
      })
    assert_not flash.empty?
  end

  test "test teacher6 open course6 " do
    log_in_as(@teacher6)
    get open_course_path(@course6)
    assert_not flash.empty?
  end

  test "test teacher6 close course6 " do
    log_in_as(@teacher6)
    get close_course_path(@course6)
    assert_not flash.empty?
  end

  test "test teacher6 delete course6 " do
    log_in_as(@teacher6)
    delete course_path(@course6)
    assert_not flash.empty?
  end
end
