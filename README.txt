Quick app to demonstrate using different RACK APPS within an App.

REQUIREMENTS
 - gem install isolate
 - gem install unicorn (to use tasks/app.rake tasks)
 - gem install racksh (to use taks/app.rake tasks)
 
NOTES

- Shared Models reside in app/models

- Different sinatra apps reside in app/sinatra.  They all subclass MyApp::Base

- Different views for each app reside in app/views/#{app_name}

- Shared libraries reside in lib/

- /lib/helpers.rb contains sinatra helpers, that can be loaded into only
  the particular apps that need them

- Config.ru maps the app to the path (eg: /admin => AdminApp)

- Password for logging into the User, API, and Admin apps are 
  "USER", "ADMIN", "VENDOR" (see app/models/persons/*.rb)

INTERESTING

Here are some things that you might find interesting.

- Rakefile | tasks/app.rake
  Helpers to use rake to start, stop, etc...  I like using racksh for
  a ./script/console alternative.  Racksh is nice you can also test your
  app with it (eg:  $rack.get('/'))
  
- app/sinatra/admin.rb
  Check out the 'get %r{^\/(\w+)$} do'.  I use that to serve erb files
  that exist in the static views directory.  Easy way to generate views
  without creating a route.
  
- lib/helpers.rb
  Check out the different helpers.  Some are stolen like throw_content and
  content_for.  Some are merb-ish such as the concepts in SinatraApiHelperMethods.
  Notice the redirect method that actually works within sub-apps.
  eg: redirect '/session' in the AdminApp actually redirects to /admin/session.
  
- lib/configurator.rb | init.rb
  This is used for a global settings.  Its fun to use.  See the yaml file in
  config/settings.yml.  It gives you dot-notation on the yml file based on the
  RACK_ENV you are in.
  
  eg: RACK_ENV=development rake app:shell
  
  development:
    <<: *defaults
    monkey:
      name: Bob
      age: 3
    dog: false
      
  Settings = Configurator.load
  Settings.monkey # {"name"=>"Bob", "age"=>3} 
  Settings.monkey.name # Bob
  Settings.monkey.age # 3
  Settings.dog # false
  
  