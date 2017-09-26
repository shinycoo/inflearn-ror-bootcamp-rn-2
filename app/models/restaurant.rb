class Restaurant < ActiveRecord::Base
  resourcify
  include Authority::Abilities
    
  belongs_to :user
  has_many :posts
  
  mount_uploader :images, PostUploader
  serialize :images, JSON
end
