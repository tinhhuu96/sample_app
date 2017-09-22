class UsersController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])
    return if @user
    flash[:warning] = t "errorss"
    redirect_to action: "index"
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "messeger"
      redirect_to @user
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation)
  end
end
