require 'fileutils'
path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'tmp'))
worker_processes 2
pid "#{path}/unicorn.pid" 
listen "#{path}/unicorn.sock", :backlog => 1024
stderr_path "log/unicorn.log"
stdout_path "log/unicorn.log"
