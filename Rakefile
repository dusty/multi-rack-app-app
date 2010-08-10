require 'config/gems'
require "isolate/rake"

# Initialize app
task :init do
  require 'init'
end

Dir["tasks/*.rake"].each {|rake| import rake}
