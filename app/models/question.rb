class Question < ActiveRecord::Base
  belongs_to :destination
  has_many :answers
end