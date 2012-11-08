class Query < ActiveRecord::Base
  belongs_to :course
  
  attr_accessible :question, :answer, :solved, :notes,
                  :course_official_id, :course_name,
                  :student_official_id, :student_last_name, :student_first_name,
                  :teacher_official_id, :teacher_last_name, :teacher_first_name
end
