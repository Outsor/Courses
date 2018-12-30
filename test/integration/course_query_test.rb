require 'test_helper'

class CourseQueryTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user2 = users(:czj2)
    @teacher6 = users(:teacher6)
    @course2 = courses(:two)

  end


  test "course index for student login" do
    log_in_as(@user2)
    get courses_url
    assert_select "h3", "已选课程"
    assert_response 200
  end

  test "course index for student no login" do
    get courses_url
    assert_not flash.empty?
  end

  test "course index for teacher login" do
    log_in_as(@teacher6)
    get courses_url
    assert_select "h3", "授课列表"
    assert_response 200
  end

  test "course list for student" do
    log_in_as(@user2)
    get list_courses_url
    assert_response 200
    assert_select "h5", "当前查询条件:"
  end

  test "course query by department student" do
    log_in_as(@user2)
    get list_courses_url(params: {"department" => "网安学院"})
    assert_response 200
    assert_select "h5", "当前查询条件:网安学院"
  end

  test "course query by course_type for student" do
    log_in_as(@user2)
    get list_courses_url(params: {"type" => "专业核心课"})
    assert_response 200
    assert_select "h5", "当前查询条件:  专业核心课"
  end

  test "course query by time for student" do
    log_in_as(@user2)
    get list_courses_url(params: {"time" => "周一"})
    assert_response 200
    assert_select "h5", "当前查询条件:    周一"
  end

  test "course query by name for student" do
    log_in_as(@user2)
    get list_courses_url(params: {"name" => "高级软件"})
    assert_response 200
    assert_select "h5", "当前查询条件:      高级软件"
  end

  test "course query by department_time_name for student" do
    log_in_as(@user2)
    get list_courses_url(params: {"type" => "专业核心课", "time" => "周一", "name" => "高级软件", })
    assert_response 200
    assert_select "h5", "当前查询条件:  专业核心课  周一  高级软件"
  end

end
