require 'test_helper'

class CourseTableTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user2 = users(:czj2)
  end

  test "course_table for student login" do
    log_in_as(@user2)
    get my_course_list_courses_url
    assert_response 200
  end

  test "credits statistic for student login" do
    log_in_as(@user2)
    get credit_statistics_courses_url
    assert_response 200
  end
  
end
