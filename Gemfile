source 'https://rubygems.org'

gem 'rails', '3.2.5'
gem 'bcrypt-ruby', '3.0.1'
gem 'faker', '1.0.1'
gem 'will_paginate', '3.0.3'
gem "haml-rails"
gem 'rvm'

group :development, :test do
  gem 'rspec-rails', '2.8.1'
	gem 'guard-rspec', '0.5.5'
	gem 'annotate', '~> 2.4.1.beta'
  gem "capistrano"
  gem "rvm-capistrano"
end

gem 'pg', '0.12.2'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '3.2.4'
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '1.2.3'
end

gem 'jquery-rails'

group :test do
	gem 'rspec-rails', '2.8.1'
  gem 'capybara', '1.1.2'
  gem 'guard-spork', '0.3.2'
  gem 'spork', '0.9.0'
  gem 'factory_girl_rails'
  gem "shoulda-matchers", "~> 1.0.0"
  gem 'database_cleaner'
  #System-dependent gems
  gem 'rb-inotify', '0.8.8'
  gem 'libnotify', '0.5.9'
end

gem :production do
  gem 'daemon_controller', '1.0.0'
  gem "passenger", '3.0.12'
  gem 'i18n', '0.6.0'
end