# Isolate
require 'config/gems'

# Include required gems
%w{ sinatra/base rack-flash active_support }.each {|req| require req }

# Require custom libraries
Dir["lib/*.rb"].sort.each {|req| require req}

# Global settings for app
Settings = Configurator.load

# Require app code
Dir["app/models/**/*.rb"].sort.each {|req| require req}
Dir["app/sinatra/*.rb"].sort.each {|req| require req}
