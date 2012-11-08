class Course < ActiveRecord::Base
  has_many :entries, :dependent => :destroy
  has_many :queries, :dependent => :destroy
  has_and_belongs_to_many :users
  
  attr_accessible :official_id, :name, :description, :notes
  
  validates_uniqueness_of   :official_id, :case_sensitive => false#, :on => :create
end
