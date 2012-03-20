Quick app to demonstrate using different RACK APPS within an App.

SETUP
 $ gem install bundler
 $ bundle install --path vendor
 $ rake run

NOTES

- Shared Models reside in models/

- Different sinatra apps reside in app/.  They all subclass MyApp::Base

- Different views for each app reside in views/#{app_name}

- Shared libraries reside in lib/

- lib/helpers.rb contains sinatra helpers that can be loaded into only
  the particular apps that need them

- Config.ru maps the app to the path (eg: /admin => AdminApp)


INTERESTING

Here are some things that you might find interesting.

- Rakefile
  Helpers to use rake to start, stop, etc...

  Racksh is a nice script/console alternative.  You can also test your
  app with it (eg:  $rack.get('/'))

  If you have relay (gem install relay) installed and your .ssh/config
  file setup there is a simple capistrano replacement for deploying your
  app.  Check out the deploy namespace.

- app/admin.rb
  Check out the 'get %r{^\/(\w+)$} do'.  That can serve erb files
  that exist in the static views directory.  Easy way to generate views
  without creating a route.

- lib/helpers.rb
  Check out the different helpers.  Some are stolen like throw_content and
  content_for.  Some are merb-ish such as the concepts in SinatraApiHelperMethods.

- lib/configurator.rb
  This is used for a global settings.  See the yaml file in config/settings.yml.
  It gives you dot-notation on the yml file based on the RACK_ENV you are in.

  eg: RACK_ENV=development rake app:shell

  # config/settings.yml
  development:
    <<: *defaults
    monkey:
      name: Bob
      age: 3
    dog: false

  Settings = Configurator.load('config/settings.yml')
  Settings.monkey # {"name"=>"Bob", "age"=>3}
  Settings.monkey.name # Bob
  Settings.monkey.age # 3
  Settings.dog # false

