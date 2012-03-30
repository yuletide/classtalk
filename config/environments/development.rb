Classtalk::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  config.time_zone = "Eastern Time (US & Canada)"

  $outbound_flocky = Flocky.new ENV['FLOCKY_TOKEN'],ENV['FLOCKY_APPNUM'],{:username=>ENV['FLOCKY_USERNAME'],:password=>ENV['FLOCKY_PASSWORD']}, :queue => false

  # $outbound_flocky = Flocky.new(1234,5678,90)
  #   def $outbound_flocky.message(from,message,numbers)
  #     puts "LOGG: sending a message '#{message}' from #{from} to #{numbers.inspect}"
  #   end
  # 
  #   def $outbound_flocky.create_phone_number_synchronous(area_code)
  #     num = area_code+Array.new(7) {("0".."9").to_a[rand(10)]}*""
  #     puts "LOGG: provision number #{num}"
  #     response= Object.new
  #     def response.code
  #       200
  #     end
  #     def response.parsed_response
  #       {"href"=>"https://api.tropo.com/v1/applications/1234/addresses/number/+#{@num}"}
  #     end
  #     response.instance_variable_set("@num",num)
  #     {:url=>nil, :response=>response}
  #   end
  #   def $outbound_flocky.destroy_phone_number_synchronous(phone_number)
  #     puts "LOGG: destroy phone provision #{phone_number}"
  #   end
  #   def $outbound_flocky.create_phone_number_asynchronous(area_code)
  #     create_phone_number_synchronous(area_code)
  #   end
  #   def $outbound_flocky.destroy_phone_number_asynchronous(area_code)
  #     destroy_phone_number_synchronous(area_code)
  #   end

end

