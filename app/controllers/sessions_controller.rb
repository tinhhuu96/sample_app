class SessionsController < ApplicationController
  def suport user
    params[:session][:remember_me] == Settings.session.value_checkbox ? remember(user) : forget(user)
  end

  def validate_true user
    if user.activated?
      log_in user
      suport user
      redirect_back_or user
    else
      message  = t "ms1"
      message += t "ms2"
      flash[:warning] = message
      redirect_to root_url
    end
  end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      validate_true user
    else
      flash.now[:danger] = t "error_login"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
