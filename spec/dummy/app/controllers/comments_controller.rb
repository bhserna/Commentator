class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(message: params[:message])

    if @comment.save
      render json: @comment.commentator_json(view_context)
    else
      render :nothing
    end
  end

  def reply
    @comment = Comment.new(params[:comment_id])
    @reply = @comment.replies.new(message: params[:message])

    if @reply.save
      render json: @reply
    else
      render :nothing
    end
  end
end
