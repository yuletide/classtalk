class Question < ActiveRecord::Base
  belongs_to :destination
  has_many :answers
  validates_uniqueness_of :order_index, :scope => :destination_id
end