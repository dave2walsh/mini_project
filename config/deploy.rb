require "rvm/capistrano"

server_ip = "192.168.2.5"

#Name of application
set :application, "mini_test"

#Location of repository
set :repository,  "git@github.com:dave2walsh/mini_project.git"

#Repository type
set :scm, :git

#Detect rubyversion@gemset gemset used for deployment
set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")

#Branch to use for pushing code
set :branch, "master"

#Only fetch the changes since the last deploy
set :deploy_via, :remote_cache

#Directory on the server to deploy to
set :deploy_to, "/home/dave/Rails_Projects/wordjack_test"

#Use local keys instead of those on the server
ssh_options[:forward_agent] = true

#ssh username
set :user, "dave"

#ssh/sudo password
set :password, "the_daddyo"

#Use this to avoid "no tty present and no askpass program specified" error
default_run_options[:pty] = true

#Only keep the last five latest releases, otherwise the server gets too full of old releases. Works with bundle exec cap deploy:cleanup
set :keep_releases, 5

#Deoployment locations
role :web, server_ip                          # Your HTTP server, Apache/etc
role :app, server_ip                          # This may be the same as your `Web` server
role :db,  server_ip, :primary => true # This is where Rails migrations will run

#Run tasks for rvm installation on server
before 'deploy:setup', 'rvm:install_rvm'   # install RVM
before 'deploy:setup', 'rvm:install_ruby'  # install Ruby and create gemset

#Clean up old releases on each deploy
after "deploy:restart", "deploy:cleanup"

#Order in which tasks are executed
after "deploy", "deploy:bundle_gems"
after "deploy:bundle_gems", "deploy:restart"

#Run bundle. Restart nginx without breaking any current connections
namespace :deploy do
  task :bundle_gems do
    run "cd #{deploy_to}/current && bundle install"
  end
  task :restart do
    run "#{sudo} kill -HUP `cat /opt/nginx/logs/nginx.pid`"
  end
end