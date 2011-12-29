class Student < ActiveRecord::Base
  belongs_to :group
  belongs_to :active_checkin, :class_name=>'Checkin'
  has_many :logged_messages, :as=>:sender, :dependent=>:nullify
  has_many :answers
  has_many :checkins

  validates_uniqueness_of :phone_number,
    :scope       => :group_id,
    :allow_blank => true,
    :allow_nil   => true
  validates_presence_of :name

  #for the moment, we expect standard, US-style 10 digit area code/number. we assume a country code of 1.
  validates_phone_number :phone_number, :allow_blank=>true

  validate :notification_method_present?

  private

  def notification_method_present?
    unless [phone_number, email].any?(&:present?)
      errors.add(:base, "either phone_number or email must be present")
    end
  end
end
