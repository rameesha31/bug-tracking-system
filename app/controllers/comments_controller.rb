class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @bug = Bug.find(params[:bug_id])

    @comment = @bug.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to bug_path(@bug), notice: "Comment added successfully!"
    else
      redirect_to bug_path(@bug), alert: "Comment cannot be empty."
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @bug = @comment.bug

    unless @comment.user == current_user
        redirect_to bug_path(@comment.bug), alert: "You cannot delete this comment."
        return
      end
      
    @comment.destroy
  
    redirect_to bug_path(@bug), notice: "Comment deleted successfully!"
  end
  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
