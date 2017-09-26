class Post < ActiveRecord::Base
    resourcify
    include Authority::Abilities
    
    has_many :comments
    belongs_to :user
    belongs_to :restaurant
  
    mount_uploader :image, PostUploader
end
