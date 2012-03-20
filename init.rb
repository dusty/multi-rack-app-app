# Bundler
require "rubygems"
require "bundler/setup"

# Include required gems
%w{ sinatra/base rack-flash active_model }.each {|req| require req }

# Require custom libraries
Dir["lib/*.rb"].sort.each {|req| require_relative req}

## Global Settings
Settings = Configurator.load('config/settings.yml')

# Require app code
Dir["models/**/*.rb"].sort.each {|req| require_relative req}
Dir["app/*.rb"].sort.each {|req| require_relative req}
