class NotificationMailer < ActionMailer::Base
  def notification_email(message,user,group)
    mail(:to=>user.email, 
      :from=>"group+#{group.id}@classtalk-staging.heroku.com",
      :subject=>"Update from #{group.title}") do |format|
      format.text {render :text=>message}
    end
  end
end
