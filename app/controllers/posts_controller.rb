class PostsController < ApplicationController

  before_action :check_logged_in?

  def index
    page = params[:page].to_i || 1
    per_page = 2  
    offset = (page - 1) * per_page
    @posts = Post.where(is_public: true).order(created_at: :desc).limit(per_page).offset(offset)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = session[:user_id]
  
    if @post.save
      redirect_to posts_path, notice: "Posted Successfully"
    end
  end

  def user_posts
    unless is_admin?(current_user)
      redirect_to posts_path, notice: "Action Restricted"
    end
    page = params[:page].to_i || 1
    @per_page = 2
    offset = (page - 1) * @per_page
    @posts = Post.where(user_id: session[:user_id]).order(created_at: :desc).limit(@per_page).offset(offset)
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :is_public)
  end

  def check_logged_in?
    unless logged_in?
      redirect_to root_path, alert: "Please Sign In Before Continuing"
    end
  end
end
