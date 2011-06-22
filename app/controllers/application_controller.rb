class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :ensure_domain if Rails.env.production?
    
  def index
    if user_signed_in?
      redirect_to :groups
    else
      redirect_to "/welcome"
    end
    #render welcome page by default
  end
  
  def ensure_domain
    if request.env['HTTP_HOST'] != ENV["APP_DOMAIN"]
      # HTTP 301 is a "permanent" redirect
      redirect_to "http://#{ENV["APP_DOMAIN"]}", :status => 301
    end
  end
end