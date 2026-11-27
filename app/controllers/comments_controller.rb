class CommentsController < ApplicationController
  include Authentication

  def create
    @bug = Bug.find(params[:bug_id])

    @comment = @bug.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html do
          redirect_to bug_path(@bug), notice: "Comment added successfully!"
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("comment_form",partial: "comments/form",locals: { bug: @bug, comment: @comment }), 
          status: :unprocessable_entity
        end
        format.html do
          redirect_to bug_path(@bug), alert: "Comment cannot be empty."
        end
      end
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
  
    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_to bug_path(@bug), notice: "Comment deleted successfully!"
      end
    end
  end
  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
