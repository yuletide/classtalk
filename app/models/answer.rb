class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :student
  validates_uniqueness_of :question_id, :scope=>:student_id
end
