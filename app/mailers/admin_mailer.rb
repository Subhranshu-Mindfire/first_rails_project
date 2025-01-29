class AdminMailer < ApplicationMailer
    def confirmation_email(admin)
        @admin = admin

        
        # binding.pry
        
        # @url  = edit_admin_url(@admin)
        
        # binding.pry
        
        mail(to: @admin[:admin][:email], subject: "Confirmation of Admin Site")
    end
end
