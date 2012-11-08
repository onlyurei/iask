class Keyword < ActiveRecord::Base
  has_many :relevances, :dependent => :destroy
  has_many :entries, :through => :relevances
  
  attr_accessible :value, :notes, :relevance
  
  validates_uniqueness_of :value, :on => :create
end
