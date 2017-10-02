class PasswordResetsController < ApplicationController
  before_action :gett_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "password_resets_1"
      redirect_to root_url
    else
      flash.now[:danger] = t "password_resets_2"
      render :new
    end
  end

  def edit; end

  def flase_validate
    if @user.update_attributes user_params
      log_in @user
      @user.update_attributes reset_digest: nil
      flash[:success] = t "password_resets_3"
      redirect_to @user
    else
      render :edit
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t("password_resets_er_1"))
      render :edit
    else
      flase_validate
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def gett_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    redirect_to root_url unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t "password_resets_4"
    redirect_to new_password_reset_url
  end
end
