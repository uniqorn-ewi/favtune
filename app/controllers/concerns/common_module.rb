module CommonModule
  extend ActiveSupport::Concern

  def signed_in_user
    redirect_to signin_path unless signed_in?
  end

  included do
    helper_method :current_user, :signed_in?

    def current_user
      if session[:user_id]
        @current_user ||= User.find_by(id: session[:user_id])
      end
    end

    def signed_in?
      !current_user.nil?
    end
  end
end
