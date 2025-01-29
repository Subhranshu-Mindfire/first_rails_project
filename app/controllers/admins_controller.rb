class AdminsController < ApplicationController
    def index

    end

    def new        
        if logged_in?
            redirect_to users_path
        else
            @admin = Admin.new
        end
    end

    def create
        @admin = Admin.new(admin_params)
        if @admin.save
            
            # binding.pry
            
            AdminMailer.confirmation_email(admin: @admin).deliver_now
            redirect_to new_admin_path, notice: "Confirmation mail has been sent through the mail."
        else
            flash.now[:alert] = @admin.errors.full_messages.to_sentence
            # render turbo_stream: [turbo_stream.update("flash", partial: "shared/flash")]
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        admin_id = params[:id]
        admin = Admin.find(admin_id)
        admin[:is_confirmed] = true
        admin.save
        session[:user] = admin
        redirect_to users_path, notice: "Signed up and logged in successfully "
    end
end


private 
def admin_params
    params.require(:admin).permit(:email, :password, :password_confirmation)
end