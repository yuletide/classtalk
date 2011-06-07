This is a Rails app that does things

Users can't register, they can only be provisioned by admins.
To provision, go to rails console, and issue User.create(:email=>"their_email@place.ya"). They'll be sent a confirmation email (or in dev mode, it'll be printed in logs) 

Deploying:

the following environment variables must be set: 
FLOCKY_TOKEN,FLOCKY_USERNAME,FLOCKY_PASSWORD,FLOCKY_APPNUM
These are the API token, username, password, and appnumber for your tropo app

you can get your appnumber by visiting https://api.tropo.com/v1/applications

App domain classtalk.org redirects from heroku URL using heroku config variable. To set the key APP_DOMAIN use: heroku config:add APP_DOMAIN=your.domain.com --app <heroku-appname>


on heroku, the following plugins are used:
sendgrid, cloudmailin, cron

Setting up incoming email
1) install the cloudmailin plugin on heroku
2) look at 'heroku config' for your app, to get the username and password
3) on cloudmailin.com, add the desired incoming domain as a custom domain
4) on your DNS server, add 'clients.cloudmailin.net' as a CNAME for your desired subdomain/domain.
resources: http://docs.cloudmailin.com/custom_domains, http://devcenter.heroku.com/articles/cloudmailin

[![Code for America Tracker](http://stats.codeforamerica.org/codeforamerica/homework_notifier.png)](http://stats.codeforamerica.org/projects/homework_notifier)


Testing:
the APP_DOMAIN environment variable must be set, to "test.host"
