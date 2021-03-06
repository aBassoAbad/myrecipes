class ApplicationController < ActionController::Base
    skip_before_action :verify_authenticity_token
    helper_method :current_chef, :logged_in?

    def current_chef
        @current_chef ||= Chef.find(session[:chef_id]) if session[:chef_id]
    end

    def logged_in?
        !!current_chef
    end

    def require_user
        if !logged_in?
            flash[:danger] = "You must be logged in to preform that action"
            redirect_to root_path
        end
    end
end
