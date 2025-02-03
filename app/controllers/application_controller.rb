class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  # before_action :check_loggedin

  helper_method :current_user, :logged_in?, :is_admin?

  $post = Post.new
  $comment = Comment.new

  def logged_in?
    current_user
  end

  def check_loggedin
    redirect_to login_path unless logged_in?
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def is_admin?(current_user)
    admin = Role.find_by(title: "Admin")
    if current_user and current_user.roles.include?(admin)
      return true
    else
      return false
    end
  end
end
