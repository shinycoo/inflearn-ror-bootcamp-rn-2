Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  
  root 'restaurant#list'

  get 'restaurant/detail'

  get 'restaurant/search'

  get 'restaurant/map'

  get 'restaurant/new'

  post 'restaurant/create'

  get 'restaurant/modify'

  post 'restaurant/update'

  get 'restaurant/delete'

  get 'user/profile' ## 내 프로필 수정 폼 and 다른 사용자의 정보 보기 
  
  post 'user/profile'

  post 'comment/create'

  get 'comment/delete'

  post 'post/create'

  get 'post/new'
  
  get 'post/modify'
  
  post 'post/update'
  
  get 'post/delete'
  
  get 'post/list'
  
  get 'post/detail'

end
