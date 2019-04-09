class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        session[:user_id] = user.id
        redirect_to user_path(user.id)
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash.now[:danger] = message
        render :new
      end
    else
      flash.now[:danger] = "Failed in sign in ..."
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = "Sign out was done."
    redirect_to root_path
  end
end
