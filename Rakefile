require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = "test/*_test.rb"
end

## Manage app startup/shutdown

desc "Run app in foreground"
task :run do
  sh "bundle exec thin start"
end

desc "Start app server"
task :start do
  sh "bundle exec thin start -C config/thin.yml"
end

desc "Stop app server"
task :stop do
  sh "bundle exec thin stop -C config/thin.yml"
end

desc 'Restart app server'
task :restart do
  sh "bundle exec thin stop -C config/thin.yml; bundle exec thin start -C config/thin.yml"
end

desc "Start app IRB session"
task :shell do
  sh "bundle exec racksh"
end

## Manage app deployment

desc "Run full deployment"
task :deploy do
  remote "git fetch && git reset --hard origin/master && bundle install --deployment && rake restart"
end

namespace :deploy do

  desc "Setup app for deployment"
  task :setup do
    remote "cd .. && git clone git@github.com:MYGITUSER/MYGITPROJECT.git"
  end

  desc "Deploy app to server"
  task :update do
    remote "git fetch && git reset --hard origin/master"
  end

  desc "Install ruby gems"
  task :bundle do
    remote "bundle install --deployment"
  end

  desc "Restart server"
  task :restart do
    remote "rake restart"
  end

  desc "Stop server"
  task :stop do
    remote "rake stop"
  end

  desc "Start server"
  task :start do
    remote "rake start"
  end

  def remote(command)
    hosts = %w{ MYAPPSERVER1 MYAPPSERVER2 }
    sh "relay -c 'cd /var/www/MYAPP && #{command}' #{hosts.join(' ')}"
  end

end
