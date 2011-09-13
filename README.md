# Class Talk
A Ruby on Rails application for sending group text messaging

## <a name="ci">Continuous Integration</a>
[![Build Status](https://secure.travis-ci.org/codeforamerica/classtalk.png)](http://travis-ci.org/codeforamerica/classtalk)

## <a name="demo">Demo</a>
You can see a running version of the application at
[http://classtalk.org/](http://classtalk.org/).

## <a name="installation">Installation</a>
    git clone git@github.com:codeforamerica/classtalk.git
    cd classtalk
    bundle install
    rake db:migrate

## <a name="usage">Usage</a>
    rails server

Users can't register, they can only be provisioned by admins.
To provision, go to rails console, and issue User.create(:email=>"theiremail@place.ya"). They'll be sent a confirmation email (or in dev mode, it'll be printed in logs)

## <a name="deploying">Deploying:</a>

The following environment variables must be set:
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


## <a name="contributing">Contributing</a>
In the spirit of [free software](http://www.fsf.org/licensing/essays/free-sw.html), **everyone** is encouraged to help improve this project.

Here are some ways *you* can contribute:

* by using alpha, beta, and prerelease versions
* by reporting bugs
* by suggesting new features
* by writing or editing documentation
* by writing specifications
* by writing code (**no patch is too small**: fix typos, add comments, clean up inconsistent whitespace)
* by refactoring code
* by closing [issues](https://github.com/codeforamerica/classtalk/issues)
* by reviewing patches
* [financially](https://secure.codeforamerica.org/page/contribute)

## <a name="issues">Submitting an Issue</a>
We use the [GitHub issue tracker](https://github.com/codeforamerica/classtalk/issues) to track bugs and
features. Before submitting a bug report or feature request, check to make sure it hasn't already
been submitted. You can indicate support for an existing issuse by voting it up. When submitting a
bug report, please include a [Gist](https://gist.github.com/) that includes a stack trace and any
details that may be necessary to reproduce the bug, including your gem version, Ruby version, and
operating system. Ideally, a bug report should include a pull request with failing specs.

## <a name="pulls">Submitting a Pull Request</a>
1. Fork the project.
2. Create a topic branch.
3. Implement your feature or bug fix.
4. Add tests for your feature or bug fix.
5. Run <tt>bundle exec rake test</tt>. If your changes are not 100% covered, go back to step 4.
6. Commit and push your changes.
7. Submit a pull request. Please do not include changes to the gemspec or version file. (If you want to create your own version for some reason, please do so in a separate commit.)

## <a name="rubies">Supported Rubies</a>
This library aims to support and is [tested
against](http://travis-ci.org/codeforamerica/classtalk) the following
Ruby implementations:

* Ruby 1.8.7
* Ruby 1.9.2
* [Ruby Enterprise Edition](http://www.rubyenterpriseedition.com/)

If something doesn't work on one of these interpreters, it should be considered
a bug.

This library may inadvertently work (or seem to work) on other Ruby
implementations, however support will only be provided for the versions listed
above.

If you would like this library to support another Ruby version, you may
volunteer to be a maintainer. Being a maintainer entails making sure all tests
run and pass on that implementation. When something breaks on your
implementation, you will be personally responsible for providing patches in a
timely fashion. If critical issues for a particular implementation exist at the
time of a major release, support for that Ruby version may be dropped.

## <a name="copyright">Copyright</a>
Copyright (c) 2011 Code for America.
See [LICENSE](https://github.com/codeforamerica/classtalk/blob/master/LICENSE.md) for details.

[![Code for America Tracker](http://stats.codeforamerica.org/codeforamerica/classtalk.png)](http://stats.codeforamerica.org/projects/classtalk)
