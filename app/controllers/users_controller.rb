class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def new
    if params[:back]
      @user = User.new(user_params)
    # unless params[:cache][:avatar].empty?
    #   @user.avatar.retrieve_from_cache! params[:cache][:avatar]
    # end
    else
      @user = User.new
    end
  end

  def confirm
    @user = User.new(user_params)
    render 'new' if @user.invalid?
  end

  def create
    @user = User.new(user_params)
    @user.status = true
  # @user.status = false
  # unless params[:cache][:avatar].empty?
  #   @user.avatar.retrieve_from_cache! params[:cache][:avatar]
  # end
    
    if @user.save
    # NotifyMailer.notify_mail(@user).deliver
      redirect_to root_path, notice: "An e-mail of invitation was sent to you."
    # redirect_to root_path, notice: "You were registered as a user."
    else
    # render 'new'
      redirect_to root_path, notice: "Error..."
    end
  end

  def show
  # @user = User.find(params[:id])
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1
  def update
  # respond_to do |format|
  #   if @user.update(user_params)
  #     format.html { redirect_to @user, notice: 'User was successfully updated.' }
  #     format.json { render :show, status: :ok, location: @user }
  #   else
  #     format.html { render :edit }
  #     format.json { render json: @user.errors, status: :unprocessable_entity }
  #   end
  # end
  end

  # DELETE /users/1
  def destroy
  # @user.destroy
  # respond_to do |format|
  #   format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
  #   format.json { head :no_content }
  # end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(\
      :name, :email, :password, :password_confirmation)
    # :name, :email, :password, :password_confirmation, :avatar, :avatar_cache)
  end
end
