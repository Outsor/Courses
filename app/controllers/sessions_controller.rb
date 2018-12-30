class SessionsController < ApplicationController
  include SessionsHelper

  def create
    user = User.find_by(email: login_params[:email].downcase)
    if user && user.authenticate(login_params[:password])
      if user.active
        log_in user
        params[:session][:remember_me] == '1' ? remember_user(user) : forget_user(user)
        flash = {info: "欢迎回来: #{user.name} :)"}
      else
        user.token = SecureRandom.urlsafe_base64
        if user.save
          UserMailer.account_activation(user).deliver_now
          flash = {danger: '账号未激活，激活邮件已经发送至注册邮箱，请查阅邮件，先将账号激活！'}
        end
      end
    else
      flash = {danger: '账号或密码错误'}
    end
    redirect_to root_url, flash: flash
  end

  def forgot;
  end

  def active;
  end

  def reset_act
    user = User.find_by(email: login_params[:email].downcase)
    if user
      user.password = login_params[:password]
      user.save
      flash = {info: '密码修改成功，请登陆！ :)'}
    else
      flash = {danger: 'unknown error'}
    end
    redirect_to root_url, flash: flash
    #     if @user != nil  && @user.token == params[:token] then
    #
    #     else
    #       flash= {:danger => "验证失败！请重新获取重置密码邮件！\n #{@user.token} \n#{params[:token]}"}
    #     end
  end

  def reset
    @user = User.find_by(email: params[:email].downcase)
    if !@user.nil? && @user.token == params[:token]
    else
      flash = {danger: '验证失败！请重新获取重置密码邮件！'}
      redirect_to root_url, flash: flash
    end
  end

  def send_active_email
    mail = email_params[:email].downcase
    unless mail.blank? && mail.empty?
      @user = User.find_by(email: email_params[:email].downcase)
      @user.token = SecureRandom.urlsafe_base64
      if !@user.nil? && @user.save
        UserMailer.account_activation(@user).deliver_now
        flash = {info: "激活邮件已发送至 #{mail},请注意查收！"}
      end
    end
    redirect_to root_url, flash: flash
  end

  def send_reset_email
    mail = email_params[:email]
    if mail.nil? && mail.blank?
      flash = {danger: '账号不能为空'}
    else
      @user = User.find_by(email: email_params[:email].downcase)
      if !@user.nil? && @user.save
        @user.token = SecureRandom.urlsafe_base64
        UserMailer.password_reset(@user).deliver_now
        flash = {info: "重置密码邮件已发送至 #{mail},请注意查收！"}
      else
        flash = {danger: '不存在该用户，请核对输入的用户名！'}
      end
    end
    redirect_to root_url, flash: flash
  end

  def new
    @email
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def login_params
    params.require(:session).permit(:email, :password)
  end

  def email_params
    params.require(:email).permit(:email)
  end
end
