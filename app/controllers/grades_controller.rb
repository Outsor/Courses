class GradesController < ApplicationController
  include CourseHelper

  before_action :teacher_logged_in, only: [:update]
  before_action :systeminfo_exit, only: [:index, :update]

  def update
    @grade = Grade.find_by_id(params[:id])
    if @grade.update_attributes!(:grade => params[:grade][:grade])
      flash = {:success => "#{@grade.user.name} #{@grade.course.name}的成绩已成功修改为 #{@grade.grade}"}
      UserMailer.push_grade(@grade).deliver_now
    else
      flash = {:danger => "上传失败.请重试"}
    end
    # redirect_to :back, flash: flash
    redirect_to grades_path(course_id: params[:course_id]), flash: flash
  end

  def index
    #binding.pry
    
    if teacher_logged_in?
      @course = Course.find_by_id(params[:course_id])
      @grades = @course.grades.order(created_at: "desc").paginate(page: params[:page], per_page: 6)
      
    elsif student_logged_in?
      @semesters = Course.select(:semester).distinct.collect {|p| [integrated_semester(p.semester), p.semester]}
      @semester_str = "UCAS在读期间全部成绩"
      @grades = current_user.grades
      if (params[:year_term] !="" and params[:year_term]) 
        @semester_str = integrated_semester(params[:year_term])
        @temp = []
        @grades.each do |grade|
          if grade.course.semester == params[:year_term]
            @temp << grade
          end
        end
        @grades = @temp
      end
      
    else
      redirect_to root_path, flash: {:warning => "请先登陆"}
    end
  end


  private

  # Confirms a teacher logged-in user.
  def teacher_logged_in
    unless teacher_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  def systeminfo_exit
    unless systeminfo_exit?
      redirect_to root_url, flash: {danger: '系统信息错误!管理员未填写系统信息！'}
    end
  end
end
