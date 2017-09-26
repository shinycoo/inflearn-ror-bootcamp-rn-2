class CommentController < ApplicationController
  before_action :authenticate_user!

  def create
    _id = params[:id]
    _contents = params[:contents]
    
    _post = Post.find(_id)
    
    comment = Comment.new(post: _post, contents: _contents)
    comment.user = current_user 
    comment.save
    
    redirect_to controller: 'post', action:'list'
  end

  def delete
    _id = params[:id]
    
    comment = Comment.find(_id)
    comment.destroy
    
    redirect_to controller: 'post', action:'list'
    
  end
end
