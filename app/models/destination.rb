class Destination < ActiveRecord::Base

  belongs_to :group
  has_many :questions, :order => :order_index

end
