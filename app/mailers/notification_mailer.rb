class NotificationMailer < ActionMailer::Base
  def notification_email(message,user,group)
    mail(:to=>user.email, 
      :from=>"group+#{group.id}@mail.ENV['APP_DOMAIN']",
      :subject=>"Update from #{group.title}") do |format|
      format.text {render :text=>message}
    end
  end
end
