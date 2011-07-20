class Checkin < ActiveRecord::Base
  belongs_to :destination
  belongs_to :student
end