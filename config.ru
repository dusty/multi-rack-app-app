require 'init'

run Rack::URLMap.new(
  '/'      => MyApp::UserApp.new,
  '/admin' => MyApp::AdminApp.new,
  '/api'   => MyApp::ApiApp.new
)
