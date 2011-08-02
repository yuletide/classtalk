class Question < ActiveRecord::Base
  belongs_to :destination
  has_many :answers
  
  #these validations get in conflict with our magic over in destination with questions_attributes. 
  #plus, if that's managing it, we don't have to worry about it here.
  #validates_uniqueness_of :order_index, :scope => :destination_id
  #validates_presence_of :order_index
end