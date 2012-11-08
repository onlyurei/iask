class Entry < ActiveRecord::Base
  belongs_to :course
  belongs_to :user
  has_many :relevances, :dependent => :destroy
  has_many :keywords, :through => :relevances
  
  attr_accessible :course_id, :question, :answer, :notes,
                  :user_official_id, :user_last_name, :user_first_name
                  
end
