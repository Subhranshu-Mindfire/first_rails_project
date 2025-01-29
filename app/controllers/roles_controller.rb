class RolesController < ApplicationController

    before_action :require_login_and_admin_access 

    def index
        @roles = Role.all
    end

    def new
        @role = Role.new
    end

    def create
        @role = Role.new(role_params)
        if @role.save
            redirect_to roles_path, notice: "Role Created Successfully"
        else
            flash.now[:alert] = @role.errors.full_messages.to_sentence
            # render turbo_stream: [turbo_stream.update("flash", partial: "shared/flash")]
            render :new, status: :unprocessable_entity
        end
    end
    
    def edit
        begin
            @role = find_role
        rescue ActiveRecord::RecordNotFound => e
            redirect_to '/404'
        end
    end

    def edit
        begin
            @role = find_role
          if @role.update(role_params)
              redirect_to roles_path,notice:"Role Updated Successfully"
          else
            res = ""
            @role.errors.messages.each_key do |k| 
              res += (k.to_s + " " + @role.errors.messages[k][0]+", ")
            end
            
            flash.now[:alert] = res
            # render turbo_stream: [turbo_stream.update("flash", partial: "shared/flash")]
            render :new, status: :unprocessable_entity
          end
        rescue ActiveRecord::RecordNotFound => e
          redirect_to '/404'
        end
    end

    def destroy
      begin
        @role = find_role
        @role.destroy()
        redirect_to roles_path, notice:"Role Deleted Successfully"
      rescue ActiveRecord::RecordNotFound => e
          redirect_to '/404'
      end
    end









    private
    def role_params
        params.require(:role).permit(:title, :description)
    end

    def find_role
        Role.find(params[:id])
    end

    def require_login_and_admin_access
        if !logged_in?
            redirect_to login_path, notice: "Please Sign in to Continue"
        elsif !is_admin?(current_user)
            redirect_to home_users_path, notice: "Action Restricted"
        end
    end
end
