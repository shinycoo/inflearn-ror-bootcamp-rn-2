class UserController < ApplicationController
  def profile
    @user = current_user 
    
    if request.post?
      current_user.name = params[:name]
      current_user.profile = params[:profile]
      current_user.save
      
      redirect_to :back 
    end
  end
end
