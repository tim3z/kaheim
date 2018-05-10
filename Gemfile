source 'https://rubygems.org'

ruby '2.3.7'

# can be deleted after upgrade to Bundler 2.0
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0'
# Use Postgresgem 'pg' as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', group: :doc

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'letter_opener'
  gem 'better_errors'
  gem 'binding_of_caller'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

group :development do
  # Use Capistrano for deployment
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano3-puma'
end

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'bootstrap-sass', '~> 3.2.0'
gem 'autoprefixer-rails'
gem 'bootstrap_form', '~> 2.7'

gem 'bootstrap-datepicker-rails'
gem 'font-awesome-rails'

# better links in locales yml.
gem 'it'

# cool js selects
gem 'select2-rails'

gem 'groupdate'
gem 'chartkick'

gem 'actionview-encoded_mail_to'
gem 'rails_autolink'

# bot protection with recaptcha
gem 'recaptcha', require: "recaptcha/rails"

# admin stuff
gem 'activeadmin'
# Authentication with Devise
gem 'devise'

# static pages
gem 'high_voltage'

# cron scheduling
gem 'whenever', require: false

gem 'dotenv-rails'

group :production do
  gem 'exception_notification'
end

gem 'simplecov', :require => false, :group => :test

