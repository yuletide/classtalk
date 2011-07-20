class Destination < ActiveRecord::Base

  belongs_to :group
  has_many :questions, :order => :order_index
  has_many :checkins

  def checkin(student)
    return nil unless self.group == student.group

    #this weird block syntax is here because find_or_create_by doesn't work properly with association collections in 3.0.9. see https://github.com/rails/rails/pull/358. (I'm not sure which tag this is first available in)
    cn = student.checkins.find_or_initialize_by_destination_id(self.id) do |c|
      c.update_attributes(:current_question_index=>-1, :complete=>false)
    end
    cn.save if cn.new_record?
    
    student.active_checkin = cn
    student.save
    
    send_next_question(student)
  end
  
  def send_next_question(student)
    cn = student.active_checkin
    return nil unless cn.destination == self
    
    cn.current_question_index += 1

    if (cn.current_question_index < self.questions.count) #if it's still a valid index
      q = self.questions.all[cn.current_question_index]
      self.group.send_destination_message("Question #{q.order_index}: #{q.content}",student)
    else
      cn.complete = true
      self.group.send_destination_message("All questions complete!",student)
    end
  end

end
