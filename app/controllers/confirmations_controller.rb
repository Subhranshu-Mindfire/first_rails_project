class ConfirmationsController < ApplicationController
  def edit
      user = User.find(params[:id])
      user.update(is_confirmed: :true)
      session[:user_id] = user[:id]
      redirect_to home_users_path, notice: "Signed up and logged in successfully "
  end
  def confirm
    user = User.find(params[:id])
    user.update(is_confirmed: :true)
    session[:user_id] = user[:id]
    redirect_to home_users_path, notice: "Signed up and logged in successfully "
end
end