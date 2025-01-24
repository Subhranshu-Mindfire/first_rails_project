class UserMailer < ApplicationMailer
    def welcome_email(user)
        @user = user
        @url  = "link"
        mail(to: @user.email, subject: "Welcome to Registration Portal")
    end
end
