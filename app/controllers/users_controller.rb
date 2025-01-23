class UsersController < ApplicationController

    def index
        @users = User.all
    end

    def show
        begin
            user
        rescue ActiveRecord::RecordNotFound => e
            redirect_to '/404'
        end
    end

    def new
        @user = User.new
        @roles = Role.all
    end

    def create
        
        # binding.pry
        
        @user = User.new(user_params)

        if @user.save
            
            # binding.pry
            
            roles = role_params[:roles]
            
            roles.each do |role|
                UserRole.create(user_id:@user.id, role_id:role)
            end
            
            redirect_to users_path, notice: "User Created Successfully"
        else
            flash.now[:alert] = @user.errors.full_messages.to_sentence
            # render turbo_stream: [turbo_stream.update("flash", partial: "shared/flash")]
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        @roles = Role.all
        begin
            # @user = find_user
            user
        rescue ActiveRecord::RecordNotFound => e
            redirect_to '/404'
        end
    end

    def update
        begin
          if user.update(user_params)
            roles = role_params[:roles]
            
            roles.each do |role|
              
              # binding.pry
              
              if not(user.roles.map{ |rol| rol.id}.include?(role.to_i))
                UserRole.create(user_id:@user.id, role_id:role)
              end

              
              # binding.pry
              
              (user.roles.map{ |rol| rol.id} - roles.map{|ro| ro.to_i}).each do |r|
                UserRole.find_by(user_id:user.id, role_id:r).destroy
              end
              
                 
              

            end
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
      begin
        # @user = find_user
        # user
        user.destroy()
        redirect_to users_path, notice:"User Deleted Successfully"
      rescue ActiveRecord::RecordNotFound => e
          redirect_to '/404'
      end
    end
    
    private
    def user_params
        params.require(:user).permit(:first_name, :last_name, :email)
    end

    def role_params
        params.require(:user).permit(roles:[])
    end

    def user
        @user ||= User.find(params[:id])
    end

    
end

