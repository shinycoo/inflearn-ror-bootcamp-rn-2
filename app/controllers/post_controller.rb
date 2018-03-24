class PostController < ApplicationController
  before_action :authenticate_user!, except: [ :list, :detail ]
  
  def create
    @restaurant = Restaurant.find(params[:restaurant])
    
    _title = params[:title]
    _contents = params[:contents]
    _ratings = params[:ratings]
    _image = params[:image]
    
    post = Post.new(title: _title, contents: _contents, ratings: _ratings)
    post.user = current_user
    post.restaurant = @restaurant
    post.image = _image
    post.save
    
    redirect_to controller:'restaurant', action:'detail', id: @restaurant.id
  end

  def new
    @restaurant = Restaurant.find(params[:id])
  end
  
  def list
    @posts = Post.all.paginate(page: params[:page], per_page: 5)

  end
  
  def modify
    _id = params[:id]
    @post = Post.find(_id)
    
    authorize_action_for @post
    
  end
  
  def update ## validation required
    _id = params[:id]
    _title = params[:title]
    _contents = params[:contents]
    _ratings = params[:ratings]
    
    post = Post.find(_id)
    authorize_action_for post
    
    post.ratings = _ratings
    post.title = _title
    post.contents = _contents
    
    if params[:image]
      post.image = params[:image]
    end
    
    post.save
    
    redirect_to controller: 'post', action: 'detail', id: post.id
  end
  
  def delete
    _id = params[:id]
    
    post = Post.find(_id)
    authorize_action_for post
    
    restaurant_id = post.restaurant.id
    
    post.destroy
    
    redirect_to controller: 'restaurant', action: 'detail', id: restaurant_id
  end
  
  def detail
    @post = Post.find(params[:id])
  end
end
