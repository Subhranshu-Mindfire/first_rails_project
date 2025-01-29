class SessionsController < ApplicationController
    def new
        # @session = Session.new
        redirect_to users_path, notice: "You have already Logged in" if logged_in?
    end

    def create
        @user = User.find_by(email: params[:email])
        
        
        # binding.pry
        
        if @user and @user.authenticate(params[:password]) and @user.is_confirmed == true
            session[:user_id] = @user[:id]
            redirect_to home_users_path, notice: "Logged In Succesfully"
        else
            flash[:alert] = "Invalid Credentials"
            render :new, status: :unprocessable_entity
        end
    end


    def destroy
        session[:user_id] = nil
        redirect_to root_path, notice: "logged out Successfully"
    end
end
