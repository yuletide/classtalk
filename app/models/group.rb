class Group < ActiveRecord::Base
  belongs_to :user
  attr_readonly :user_id #after being set, can't change

  has_many :students, :dependent=>:destroy
  has_many :logged_messages, :dependent=>:nullify
  has_many :destinations

  accepts_nested_attributes_for :students, :allow_destroy=>true, :reject_if=>:all_blank

  validates_phone_number :phone_number
  validates_phone_number :destination_phone_number

  before_save :notify_reply_settings_changed

  def send_message(message,sending_person,recipients=nil)
	begin
      recipients ||= students+[user] - [sending_person]

      #send sms messages to sms recipients
      numbers = recipients.map(&:phone_number).compact
      $outbound_flocky.message phone_number, message, numbers

      #log sms poutputs
      numbers.each do |destination|
        LoggedMessage.create(:group=>self,:sender=>sending_person,:source_phone=>phone_number,:destination_phone=>destination,:message=>message)
      end

      #send message to non-sms recipients (email, for now)
      recipients.select {|r| r.email.present?}.each {|recip| NotificationMailer.notification_email(message,recip,self).deliver}

      #todo: also log these messages
    rescue Exception=>e
      logger.error e.message
      logger.error e.backtrace
    end

  end
  #handle_asynchronously :send_message

  def send_destination_message(message,recipient)
    if recipient.phone_number.present?
      LoggedMessage.create(:group=>self,:sender=>nil,:source_phone=>destination_phone_number,:destination_phone=>recipient.phone_number,:message=>message)
      $outbound_flocky.message destination_phone_number, message, [recipient.phone_number]
    end

    if recipient.email.present?
      #destination email send.
    end
  end

  def notify_reply_settings_changed
    if self.replies_all_changed?
      message = "Reply settings for #{self.title} have changed. "
      message += if self.replies_all? 
        "Your replies will now be sent to everyone in the group."
      else
        "Your replies will be sent to #{user.display_name} only."
      end

      send_message(message,self.user)
    end
  end

end
