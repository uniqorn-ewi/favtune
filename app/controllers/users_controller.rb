class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :logged_in_user, only: %i[ edit show destroy ]

  def new
    if params[:back]
      @user = User.new(user_params)
    else
      @user = User.new
    end
  end

  def confirm
    @user = User.new(user_params)
    render :new if @user.invalid?
  end

  def create
    @user = User.new(user_params)
    if @user.save
      NotifyMailer.notify_mail(@user).deliver
      redirect_to root_path, notice: "An e-mail of invitation was sent to you."
    else
      redirect_to root_path, notice: "Error..."
    end
  end

  def show
  end

  def edit
    unless @user.id.eql?(current_user.id)
      redirect_to root_path, notice: "Invalid User!"
    end
  end

  def update
    if @user.update(user_params)
      redirect_to root_path, notice: "User info was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    if @user.id.eql?(current_user.id)
      session.delete(:user_id)
      @user.destroy
      redirect_to root_path, notice: "You are not registered as a user."
    else
      redirect_to root_path, notice: "Invalid User!"
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(
        :name, :email, :password, :password_confirmation)
    end

    def logged_in_user
      redirect_to new_session_path unless logged_in?
    end
end
