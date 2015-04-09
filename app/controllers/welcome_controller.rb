class WelcomeController < ApplicationController
    def index
    end

    def about
    end

    def login
        if session[:user_id] != nil
            redirect_to root_url
        else
            if params.has_key?(:pseudo) && params.has_key?(:password)
                user = User.authenticate(params[:pseudo], params[:password])
                if user
                    session[:user_id] = user.id
                    redirect_to root_url, :notice => t(:logged_in)
                else
                    flash.now.alert = t(:invalid_pseudo_or_password)
                    render "login"
                end
            else
                render "login"
            end
        end
    end

    def logout
        session[:user_id] = nil
        redirect_to root_url, :notice => t(:logged_out)
    end
end
