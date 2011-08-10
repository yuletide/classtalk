class Destination < ActiveRecord::Base

  belongs_to :group
  has_many :questions, :order => :order_index
  has_many :checkins
  
  accepts_nested_attributes_for :questions, :allow_destroy => true, :reject_if => :all_blank
  def questions_attributes_with_reordering=(attributes_collection)
    #this portion makes sure we have an array of attributes. it's taken from the original assign_nested_attributes_for_collection_association source
    #don't know how to DRY it. ah well.
    if attributes_collection.is_a? Hash
      keys = attributes_collection.keys
      attributes_collection = if keys.include?('id') || keys.include?(:id)
        Array.wrap(attributes_collection)
      else
        #but this bit is changed.
        attributes_collection.sort_by { |i, _| i.to_s.gsub(/\D/,'').to_i }.map { |_, attributes| attributes }
      end
    end

    #WARNING: this may fail in weird ways if you only do 'partial updates'
    #TODO: make that safer.
    attributes_collection = attributes_collection.each_with_index.map do |att,i|
      att.merge(:order_index => (i+1))
    end
    puts "calling with: #{attributes_collection.inspect}"
    
    #for some weird reason, 
    #  questions_attributes_without_reordering=(attributes_collection)
    #doesn't work. for now, I'll just assign directly. TODO: investigate more.
    assign_nested_attributes_for_collection_association(:questions,attributes_collection)
  end

  alias_method_chain :questions_attributes=, :reordering

  def checkin(student)
    return nil unless self.group == student.group

    #this weird block syntax is here because find_or_create_by doesn't work properly with association collections in 3.0.9. see https://github.com/rails/rails/pull/358. (I'm not sure which tag this is first available in)
    cn = student.checkins.find_or_initialize_by_destination_id(self.id) do |c|
      c.update_attributes(:current_question_index=>0, :complete=>false)
    end
    cn.save if cn.new_record?
    
    student.active_checkin = cn
    student.save
    
    send_current_question(student)
  end
  
  def send_current_question(student)
    cn = student.active_checkin
    return nil unless cn.destination == self

    if (cn.current_question_index < self.questions.count) #if it's still a valid index
      q = cn.current_question
      self.group.send_destination_message("Q#{q.order_index}: #{q.content}",student)
    else
      cn.complete = true
      self.group.send_destination_message("All questions complete!",student)
    end
    cn.save
  end

end
