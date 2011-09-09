class Checkin < ActiveRecord::Base
  belongs_to :destination
  belongs_to :student
  validates_uniqueness_of :destination_id, :scope => :student_id
  
  def current_question
    destination.questions.all[current_question_index]
  end
end