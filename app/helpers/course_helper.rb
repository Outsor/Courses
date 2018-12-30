module CourseHelper
	
	  def integrated_semester(old_semester)
    	hash_term = {"1" => "（秋季）第一学期", "2" => "（春季）第二学期", "3" => "（夏季）第三学期"}
    	year_term = old_semester.split(/-/)
    	year = year_term[0] + "-" + (year_term[0].to_i + 1).to_s + "学年"
    	term = hash_term[year_term[1]]
    	int_semester = year + term
  	end

  	def is_open_student?

  		@sys = Systeminfo.first
  		start_time = @sys.cs_start
  		end_time = @sys.cs_end
  		current_time = Time.now
  		current_time > start_time and current_time < end_time and !@sys.teacher

  	end

  	def is_open_teacher?

  		@sys = Systeminfo.last
  		start_time = @sys.cs_start
  		end_time = @sys.cs_end
  		current_time = Time.now
  		current_time > start_time and current_time < end_time and @sys.teacher

  	end

    def systeminfo_exit?

      if Systeminfo.all.count == 2
        true
      else
        false
      end
    end


    def all_degree_credits(grades,exam)
      sum = 0
      if exam == 0

          grades.each do |grades|
            sum = sum + extract_credit(grades.course.credit).to_f
          end

      else

          grades.each do |grades|
            if !(grades.grade.nil?)
              if grades.grade >=60
                sum = sum + extract_credit(grades.course.credit).to_f
              end
            end


          end

      end

      sum

    end


    def all_public_credits(grades, condition,exam)

      sum = 0
      if exam == 0
        grades.each do |grades|
        if grades.course.course_type == condition
          sum = sum + extract_credit(grades.course.credit).to_f
        end
      end
      else

        grades.each do |grades|
          if grades.course.course_type == condition
            if !(grades.grade.nil?)
               if grades.grade >= 60
              sum = sum + extract_credit(grades.course.credit).to_f
            end
          end


          end
        end
      end

      sum

    end




    def extract_credit(org_str)
      if !(org_str.nil?)

        hours_credit = org_str.split("/")
        credit = hours_credit[1]
      end

    end



  def week_data_to_num(week_data)
    param = {
        '周一' => 0,
        '周二' => 1,
        '周三' => 2,
        '周四' => 3,
        '周五' => 4,
        '周六' => 5,
        '周天' => 6,
    }
    param[week_data] + 1
  end


  def get_course_table(courses)
    course_time = Array.new(11) { Array.new(7, {'name' => '','credit'=>'', 'class_room'=>'','course_week'=>'','teacher_name'=>'','id' => ''}) }#new块，块会计算填充每个元素,二维数组，表示11节课，一周7天

    if courses
      courses.each do |cur|
        cur_time = String(cur.course_time)
        end_j = cur_time.index('(')#返回 cur_time中第一个等于 (的对象的 index
        j = week_data_to_num(cur_time[0...end_j])       #周几course_time: "周二(5-6)"
        t = cur_time[end_j + 1...cur_time.index(')')].split("-")#剔除-
        for i in (t[0].to_i..t[1].to_i).each
          course_time[(i-1)*7/7][j-1] = {
              'name' => cur.name,
              'credit'=> cur.credit,
              'class_room' =>cur.class_room,
              'course_week'=>cur.course_week,
              'teacher_name'=>cur.teacher.name,
              'id' => cur.id

          }
        end
      end
    end
    course_time
  end



  def get_course_info(courses, type, type2=nil)
    res = Set.new
    courses.each do |course|
      if type2
        res.add(course[type].to_s+'-'+course[type2].to_s)
      else
        res.add(course[type])
      end
    end
    res.to_a.sort
  end

  def get_student_course()
    course = []
    current_user.grades.each do |x|
      course << x.course
    end
    course
  end

  def get_current_semester()
    current_semester = Systeminfo.first.semester
  end


	def integrated_semester(old_semester)

    hash_term = {"1" => "（秋季）第一学期", "2" => "（春季）第二学期", "3" => "（夏季）第三学期"}
    year_term = old_semester.split(/-/)
    year = year_term[0] + "-" + (year_term[0].to_i + 1).to_s + "学年"
    term = hash_term[year_term[1]]
    int_semester = year + term

  end

  def is_open_student?

  	@sys = Systeminfo.first
  	start_time = @sys.cs_start
  	end_time = @sys.cs_end
  	current_time = Time.now
  	current_time > start_time and current_time < end_time and !@sys.teacher

  end

  def is_open_teacher?

  	@sys = Systeminfo.last
  	start_time = @sys.cs_start
  	end_time = @sys.cs_end
  	current_time = Time.now
  	current_time > start_time and current_time < end_time and @sys.teacher

  end

  def is_over_number?(course)
    if course[:student_num] >= course[:limit_num]
      true
    else
      false
    end
  end


  def is_exit_course?(id)
    if current_user.courses.where(:semester => current_semester).find_by_id(id)
      true
    else
      false
    end
  end

  def is_time_conflict?(wanted_course)
    flag = false
    org_course_time = wanted_course.course_time
    org_course_week = wanted_course.course_week
    courses = current_user.courses.where(:semester => current_semester)
    day_week = org_course_time[0] + org_course_time[1]
    course_time = org_course_time.scan(/\d+/)
    course_week = org_course_week.scan(/\d+/)

    if !courses.where('course_time like :str', str: "%#{day_week}%")
      flag = false
    else
      courses.each do |course|
        temp_week = course.course_time[0] + course.course_time[1]
        if !interval_overlap(course_time, course.course_time.scan(/\d+/))
          flag = false
        elsif interval_overlap(course_week, course.course_week.scan(/\d+/)) and (temp_week == day_week)
          flag = true
          break
        else
          flag = false
        end
        temp_week = ""
      end
    end
    flag
  end

  def interval_overlap(interval1, interval2)
    if (interval1[0].to_i > interval2[1].to_i) or (interval2[0].to_i > interval1[1].to_i)
      false
    else
      true
    end
  end

  def current_semester
    Systeminfo.first.semester
  end

  def systeminfo_exit?

    if Systeminfo.all.count == 2
      true
    else
      false
    end
  end


end
