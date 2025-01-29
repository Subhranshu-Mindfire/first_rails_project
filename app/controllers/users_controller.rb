class UsersController < ApplicationController

  before_action :check_admin, only: [:index, :destroy]

    def index
      if logged_in?
        @users = User.all if logged_in?
      else
        redirect_to login_path, notice: "Please Log in to continue"
      end
    end

    def show
      if logged_in?
        if current_user[:id] != params[:id].to_i
          redirect_to home_users_path, notice: "Action Restricted"
        else
          begin
              user
          rescue ActiveRecord::RecordNotFound => e
              redirect_to '/404'
          end
        end
      else
        redirect_to login_path, notice: "Please Log in to continue"
      end
    end

    def new
        @user = User.new
        @roles = Role.all
    end

    def create
        @user = User.new(user_params)
        roles = role_params[:roles]
        

        if roles.present?
          roles = roles.map!{|role| role.to_i}
          @user.roles = Role.where(id: roles)
        end

        if @user.save
          # UserMailer.welcome_email(@user).deliver_now
          # redirect_to users_path, notice: "User Created Successfully"
          UserMailer.confirmation_email(@user).deliver_now
          redirect_to new_user_path, notice: "Confirmation mail has been sent through the mail."
        else
            flash.now[:alert] = @user.errors.full_messages.to_sentence
            # render turbo_stream: [turbo_stream.update("flash", partial: "shared/flash")]
            render :new, status: :unprocessable_entity
        end
    end

    def edit
      
      # binding.pry
      
      if logged_in?
        if current_user[:id] != params[:id].to_i
          redirect_to home_users_path, notice: "Action Restricted"
        else
          @roles = Role.all
          begin
              user
          rescue ActiveRecord::RecordNotFound => e
              redirect_to '/404'
          end
        end
      else
        redirect_to login_path, notice: "Please Log in to continue"
      end
    end

    def update
        begin
          if user.update(user_params)
            roles = role_params[:roles]

            if roles.blank?
              flash.now[:alert] = "User must have atleast one role"
              render :edit, status: :unprocessable_entity
              return
            end

            roles.map!{ |role| role.to_i }
            user.update(role_ids: roles)
            
            # roles.each do |role|
            #   user.user_roles
            #   if !(user.role_ids.include?(role.to_i))
            #     UserRole.create(user_id:@user.id, role_id:role)
            #   end

            #   (user.roles.map{ |rol| rol.id} - roles.map{|ro| ro.to_i}).each do |r|
            #     if UserRole.find_by(user_id:user.id, role_id:r)
            #       UserRole.find_by(user_id:user.id, role_id:r).destroy
            #     end
            #   end
            # end
            redirect_to users_path,notice:"User Updated Successfully"
            
            
            
          else
            flash.now[:alert] = @user.errors.full_messages.to_sentence
              # render turbo_stream: [turbo_stream.update("flash", partial: "shared/flash")]
            render :new, status: :unprocessable_entity
          end
        rescue ActiveRecord::RecordNotFound => e
          redirect_to '/404'
        end
    end

    def destroy      
      if logged_in?
        begin

          # owner_role = Role.where(title: "Owner").first
          # is_owner = user.roles.where(roles: {id: owner_role.id}).present?
    
          # if is_owner
          #   redirect_to users_path, alert:"Owner Can not be deleted"
          # else
            user.destroy
            redirect_to users_path, notice:"Successfully Deleted"     
          # end   
        rescue ActiveRecord::RecordNotFound => e
            redirect_to '/404'
        end
      else
        redirect_to login_path, notice: "Please Log in to continue"
      end
    end

    def home
      if !logged_in?
        redirect_to login_path, notice: "Pleae Log in to continue"
      end
    end
    
    private
    def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password)
    end

    def role_params
        params.require(:user).permit(roles:[])
    end

    def user
        @user ||= User.find(params[:id])
    end 

    def check_admin
      if !is_admin?(current_user)
        redirect_to home_users_path, notice: "Action Restricted"
      end
    end
end

