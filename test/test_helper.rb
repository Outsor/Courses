# 注意这里必须在 require rails/test_help 之前加入，否则不会生效
require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def is_logged_in?
    !session[:user_id].nil?
  end

  # Log in as a particular user.
  def log_in_as(user)
    session[:user_id] = user.id
  end

   def is_open_student?

    @sys = Systeminfo.first
    start_time = @sys.cs_start
    end_time = @sys.cs_end
    current_time = Time.now
    current_time > start_time and current_time < end_time and !@sys.teacher

  end

end

class ActionDispatch::IntegrationTest
  # Log in as a particular user.
  def log_in_as(user, password: 'password', remember_me: '1')
    # post sessions_login_path, params: { session: { email: user.email,
    #                                       password: password,
    #                                       remember_me: remember_me } }
    post sessions_login_path(params: {session: {email: user.email,
                                                password: password,
                                                remember_me: remember_me}})
  end

  def integrated_semester(old_semester)

    hash_term = {"1" => "（秋季）第一学期", "2" => "（春季）第二学期", "3" => "（夏季）第三学期"}
    year_term = old_semester.split(/-/)
    year = year_term[0] + "-" + (year_term[0].to_i + 1).to_s + "学年"
    term = hash_term[year_term[1]]
    int_semester = year + term

  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def logged_in?
    !current_user.nil?
  end

  def student_logged_in?
    !current_user.nil? && !current_user.teacher && !current_user.admin
  end

  def teacher_logged_in?
    !current_user.nil? && current_user.teacher
  end

  def admin_logged_in?
    !current_user.nil? && current_user.admin
  end

  def is_open_student?

    @sys = Systeminfo.first
    start_time = @sys.cs_start.to_i
    end_time = @sys.cs_end.to_i
    current_time = Time.now.to_i
    current_time > start_time and current_time < end_time and !@sys.teacher
  end

  def is_open_teacher?

    @sys = Systeminfo.last
    start_time = @sys.cs_start
    end_time = @sys.cs_end
    current_time = Time.now
    current_time > start_time and current_time < end_time and @sys.teacher

  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    elsif cookies.signed[:user_id]
      user = User.find_by(id: cookies.signed[:user_id])
      if user && user.user_authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
end