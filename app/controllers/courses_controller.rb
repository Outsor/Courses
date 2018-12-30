class CoursesController < ApplicationController
  include CourseHelper
  before_action :systeminfo_exit, only: [:index, :update]
  before_action :student_logged_in, :is_open_student, only: [:select, :quit, :list, :set_degree, :cancel_degree]
  before_action :teacher_logged_in, :is_open_teacher, only: [:new, :create, :edit, :destroy, :update, :open, :close] #add open by qiao
  before_action :logged_in, only: :index
  #-------------------------for teachers----------------------
  def new
    @semester_value = Systeminfo.last.semester
    @course = Course.new
  end

  def create

    @course = Course.new(course_params)
    if @course.save
      current_user.teaching_courses << @course
      redirect_to courses_path, flash: {success: "新课程申请成功"}
    else
      flash[:warning] = "信息填写有误,请重试"
      render 'new'
    end
  end

  def edit
    @course = Course.find_by_id(params[:id])
  end

  def update
    @course = Course.find_by_id(params[:id])
    if @course.update_attributes(course_params)
      flash = {:info => "更新成功"}
    else
      flash = {:warning => "更新失败"}
    end
    redirect_to courses_path, flash: flash
  end

  def open
    @course = Course.find_by_id(params[:id])
    @course.update_attributes(open: true)
    redirect_to courses_path, flash: {:success => "已经成功开启该课程:#{ @course.name}"}
  end

  def close
    @course = Course.find_by_id(params[:id])
    @course.update_attributes(open: false)
    redirect_to courses_path, flash: {:success => "已经成功关闭该课程:#{ @course.name}"}
  end

  def destroy
    @course = Course.find_by_id(params[:id])
    current_user.teaching_courses.delete(@course)
    @course.destroy
    flash = {:success => "成功删除课程: #{@course.name}"}
    redirect_to courses_path, flash: flash
  end

  #-------------------------for students----------------------
  def list
    @sys = Systeminfo.first
    @year_term = integrated_semester(@sys.semester)
    @op_courses_type = Course.select(:course_type).distinct.collect {|p| [p.course_type]}
    @op_times = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
    @op_depts = Course.select(:department).distinct.collect {|p| [p.department]}
    @courses = Course.where(:semester => @sys.semester)
    # modify query method
    if params[:department] != "" and !params[:department].nil?
      @courses = @courses.where(:department => params[:department])
    end

    if params[:type] != "" and !params[:type].nil?
      @courses = @courses.where(:course_type => params[:type])
    end

    if params[:time] != "" and !params[:time].nil?
      @courses = @courses.where('course_time like :str', str: "%#{params[:time]}%")
    end

    if params[:name] != "" and !params[:name].nil?
      @courses = @courses.where('name like :str', str: "%#{params[:name]}%")
    end
    @courses = @courses.order(:course_code).paginate(page: params[:page], per_page: 6)
    @remind_str = params[:department].to_s + "  " + params[:type].to_s + "  " + params[:time].to_s + "  " + params[:name].to_s
  end

  def select

    @wanted_course = Course.find_by_id(params[:id])

    if is_over_number?(@wanted_course)
      flash = {:warning => "Over numbers!: #{@wanted_course.name}"}
    elsif is_exit_course?(params[:id])
      flash = {:warning => "您的课表中已存在:#{@wanted_course.name}，请选择其他课程！"}
    elsif is_time_conflict?(@wanted_course) #need to modify later
      flash = {:warning => "课程:#{@wanted_course.name}, 与课表中的课程存在时间冲突!"}
    else
      current_user.courses << @wanted_course
      if params[:degree]
        @grade = current_user.grades.find_by(course_id: params[:id])
        @grade.update(degree: true)
      end
      @wanted_course.update(student_num: @wanted_course.student_num + 1)
      flash = {:info => "成功选择课程: #{@wanted_course.name}"}
    end
    redirect_to :back, flash: flash
  end

  def set_degree
    @grade = current_user.grades.find_by_course_id(params[:id])
    if @grade.update(degree: true)
      flash = {:info => "设置成功"}
    else
      flash = {:warning => "设置失败"}
    end
    redirect_to :back, flash: flash
  end

  def cancel_degree
    @grade = current_user.grades.find_by_course_id(params[:id])
    if @grade.update(degree: false)
      flash = {:info => "取消成功"}
    else
      flash = {:warning => "取消失败"}
    end
    redirect_to :back, flash: flash
  end

  def quit
    @course = Course.find_by_id(params[:id])
    current_user.courses.delete(@course)
    @course.update(student_num: @course.student_num - 1)
    flash = {:success => "成功退选课程: #{@course.name}"}
    redirect_to courses_path, flash: flash
  end


  def credit_statistics


    @stu_type = ["学硕" , "专硕" , "直博"]
    @selected_type = params[:type]

    @all_degree_grades = current_user.grades.where(:degree => true)
    @all_not_degree_grades = current_user.grades.where(:degree => false)

    @degree_credits = all_degree_credits(@all_degree_grades,0)
    @degree_exam_credits=all_degree_credits(@all_degree_grades,1)


    @public_major_credits = all_public_credits(current_user.grades, "公共必修课",0)
    @public_major_exam_credits = all_public_credits(current_user.grades, "公共必修课",1)

    @public_not_credits = all_public_credits(@all_not_degree_grades, "公共选修课",0)
    @public_not_exam_credits = all_public_credits(@all_not_degree_grades, "公共选修课",1)


    @all_credits=all_degree_credits(current_user.grades,0)
    @all_exam_credits=all_degree_credits(current_user.grades,1)



    # @degree_courses = get_semester_course(@all_degree_grades, @semester)
    # @not_degree_courses = get_semester_course(@all_not_degree_grades, @semester)




  end

  #-------------------------for both teachers and students----------------------

  def index

    @sys_current = Systeminfo.first
    @semester_current = @sys_current.semester
    @year_term_current = integrated_semester(@semester_current)
    if teacher_logged_in?
      @sys_next = Systeminfo.last
      @semester_next = @sys_next.semester
      @year_term_next = integrated_semester(@semester_next)

      @course_next = current_user.teaching_courses.where(:semester => @semester_next).paginate(page: params[:page], per_page: 6)
      @course_current = current_user.teaching_courses.where(:semester => @semester_current).paginate(page: params[:page], per_page: 6)
    end
    if student_logged_in?
      @course_current = current_user.courses.where(:semester => @semester_current).paginate(page: params[:page], per_page: 6)
      @grades = current_user.grades
    end
  end

def my_course_list
    @course=current_user.teaching_courses.where(:semester => Systeminfo.first.semester) if teacher_logged_in?
    @course= current_user.courses.where(:semester => Systeminfo.first.semester) if student_logged_in?
    # @all_semester= get_course_info(@course, 'year', 'term_num')
    @current_semester = get_current_semester()
    semester = nil
    # if request.post?
    #   if params[:semester] !=''
    #     @current_semester = params[:semester]
    #     semester = semester_to_array(@current_semester)
    #   end
    # else
    #   semester = semester_to_array(@current_semester)
    # end
    # if semester
    #   @course= filter_course_by_semester(@course, semester)
    # else
    #   @current_semester = nil
    # end
    @course_time_table = get_course_table(@course)

  end

  private

  def is_open_student
    unless is_open_student?
      redirect_to courses_path, flash: {danger: '选课系统未开放!'}
    end
  end

  def is_open_teacher
    unless is_open_teacher?
      redirect_to courses_path, flash: {danger: '增课系统未开放!'}
    end
  end


  # Confirms a student logged-in user.
  def student_logged_in
    unless student_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  # Confirms a teacher logged-in user.
  def teacher_logged_in
    unless teacher_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  # Confirms a  logged-in user.
  def logged_in
    unless logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  def systeminfo_exit
    unless systeminfo_exit?
      redirect_to root_url, flash: {danger: '系统信息错误!'}
    end
  end

  def course_params
    params.require(:course).permit(:course_code, :name, :course_type, :teaching_type, :exam_type,
                                   :credit, :limit_num, :class_room, :course_time, :course_week,
                                   :semester, :department)
  end
end
