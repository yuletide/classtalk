# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Classtalk::Application.initialize!
#$outbound_flocky = Flocky.new ENV['FLOCKY_TOKEN'],ENV['FLOCKY_APPNUM'],{:username=>ENV['FLOCKY_USERNAME'],:password=>ENV['FLOCKY_PASSWORD']}, :queue => false
