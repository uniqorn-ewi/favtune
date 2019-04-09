class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.update_columns(activated: true, activated_at: Time.zone.now)
      session[:user_id] = user.id
      redirect_to user_path(user.id)
    else
      redirect_to root_path, notice: "Invalid activation link"
    end
  end
end
