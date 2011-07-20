Testing:
you can type 'bundle exec rake', and it will run the tests - slowly.
fortunately, we have spork, to speed things up!
in one terminal, start spork with 'bundle exec spork'
now, in another terminal, you can run your tests with 'bundle exec rspec spec'. this will run the full suite, with no overhead of loading rails!
