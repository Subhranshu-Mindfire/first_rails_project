class CommentsController < ApplicationController
  def index
    @comments = Comment.all
  end
  
  def show
  end
  
  def new
    @comment = Comment.new
  end

  
  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.post_id = params[: post_id]
    
    if @comment.save
      redirect_to posts_path, notice: "Comment Posted Successfully"
    end
  end

  private
  
  def comment_params
    params.require(: comment).permit(: content)
  end
end