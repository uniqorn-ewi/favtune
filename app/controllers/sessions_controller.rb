class SessionsController < ApplicationController
# before_action :set_session, only: [:show, :edit, :update, :destroy]

  # GET /sessions/new
  def new
  # @session = Session.new
  end

  # POST /sessions
  def create
  # @session = Session.new(session_params)
  # respond_to do |format|
  #   if @session.save
  #     format.html { redirect_to @session, notice: 'Session was successfully created.' }
  #     format.json { render :show, status: :created, location: @session }
  #   else
  #     format.html { render :new }
  #     format.json { render json: @session.errors, status: :unprocessable_entity }
  #   end
  # end
  end

  # DELETE /sessions/1
  def destroy
  # @session.destroy
  # respond_to do |format|
  #   format.html { redirect_to sessions_url, notice: 'Session was successfully destroyed.' }
  #   format.json { head :no_content }
  # end
  end

# private
#   # Use callbacks to share common setup or constraints between actions.
#   def set_session
#     @session = Session.find(params[:id])
#   end
#
#   # Never trust parameters from the scary internet, only allow the white list through.
#   def session_params
#     params.require(:session).permit(:new, :create, :destroy)
#   end
end