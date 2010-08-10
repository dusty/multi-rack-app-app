require 'rubygems'
require 'isolate'

Isolate.now! do
  gem "sinatra"
  gem "rack-flash"
  gem "activesupport"
end
