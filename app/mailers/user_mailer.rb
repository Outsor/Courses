class UserMailer < ApplicationMailer

  def account_activation(user)
    @greeting = "Hi！ "
    @user=user
    mail to: @user.email,
         :subject => '选课系统激活账号'
  end

  def password_reset(user)
    @greeting = "Hi！ "
    @user=user
    mail to: @user.email,
         :subject => '选课系统重置密码'

  end

  def push_grade(grade)
    @greeting = "Hi！！！ "
    @grade=grade
    mail to: @grade.user.email,
         :subject => '成绩推送'
  end
end
