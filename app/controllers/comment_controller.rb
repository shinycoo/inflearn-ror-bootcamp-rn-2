class CommentController < ApplicationController
  before_action :authenticate_user!

  def create
    _id = params[:post]
    _contents = params[:contents]
    
    _post = Post.find(_id)
    
    comment = Comment.new(post: _post, contents: _contents)
    comment.user = current_user 
    comment.save
    
    redirect_to controller: 'post', action:'detail', id: _id
  end

  def delete
    _id = params[:id]
    
    comment = Comment.find(_id)
    post_id = comment.post.id
    
    comment.destroy
    
    redirect_to controller: 'post', action:'detail', id: post_id
  end
end
