class Note < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :content, :created_at, :updated_at
end
