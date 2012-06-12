set :application, "mini_test"
set :repository,  "git@github.com:dave2walsh/mini_project.git"

set :scm, :git

#Detect rubyversion@gemset gemset used for deployment
set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")

set :branch, "master"
set :deploy_via, :remote_cache

set :deploy_to, "/home/dave/Rails_Projects/wordjack_test"

ssh_options[:forward_agent] = true

# ssh username
set :user, "dave"
# ssh/sudo password
set :password, "the_daddyo"

#Use this to avoid "no tty present and no askpass program specified" error
default_run_options[:pty] = true

#Only keep the last five latest releases, otherwise the server gets too full of old releases. Works with cap deploy:cleanup
set :keep_releases, 5

#Deoployment locations
role :web, "192.168.2.7"                          # Your HTTP server, Apache/etc
role :app, "192.168.2.7"                          # This may be the same as your `Web` server
role :db,  "192.168.2.7", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

after "deploy", "deploy:bundle_gems"
after "deploy:bundle_gems", "deploy:restart"

require "rvm/capistrano"

#Run bundle, restart nginx
namespace :deploy do
  task :bundle_gems do
    run "cd #{deploy_to}/current && bundle install"
  end
  task :restart do
    run "#{sudo} kill -HUP `cat /opt/nginx/logs/nginx.pid`"
  end
end