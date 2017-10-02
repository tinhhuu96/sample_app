class AccountActivationsController < ApplicationController
  def true_validate user
    user.activate
    user.update_attributes(activated: true, activated_at: Time.zone.now)
    log_in user
    flash[:success] = "Account activated!"
    redirect_to user
  end

  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      true_validate user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
