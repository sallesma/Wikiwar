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
                    redirect_to root_url, :notice => "Logged in!"
                else
                    flash.now.alert = "Invalid pseudo or password"
                    render "login"
                end
            else
                render "login"
            end
        end
    end

    def logout
        session[:user_id] = nil
        redirect_to root_url, :notice => "Logged out!"
    end
end
