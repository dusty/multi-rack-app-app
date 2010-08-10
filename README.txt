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
