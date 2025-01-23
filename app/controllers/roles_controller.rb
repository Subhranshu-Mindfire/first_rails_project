class RolesController < ApplicationController
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

    def update
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
end
