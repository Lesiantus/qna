source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.7', '>= 6.1.7.2'

gem 'pg', '~> 1.1'

gem 'puma', '~> 5.0'

gem 'sass-rails', '>= 6'

gem 'sprockets', '~> 4.0'
gem 'sprockets-rails', require: 'sprockets/railtie'

gem 'turbolinks', '~> 5'

gem 'jbuilder', '~> 2.7'

gem 'jquery-rails'
gem 'mysql2'
gem 'thinking-sphinx'

# auth
gem 'devise', '~> 4.0'
gem 'oj'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-vkontakte'
# yandex cloud setup
gem 'aws-sdk-s3', require: false
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'
gem 'active_model_serializers', '~> 0.10'
gem 'dotenv-rails'
gem 'gon'
gem 'redis', '~> 4.0'
gem 'redis-rails'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'skim'
gem 'slim-rails'
gem 'unicorn'
gem 'whenever', require: false

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false
gem 'cancancan'
gem 'cocoon'
gem 'doorkeeper'
gem 'pundit'

gem 'execjs'
gem 'mini_racer', '0.4.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails'
  gem 'localhost'
  gem 'letter_opener'
  gem 'rspec-rails', '~> 6.0.0'
  gem 'capybara-email'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-asdf', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano3-unicorn', require: false

  gem 'web-console', '>= 4.1.0'
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'ed25519'
  gem 'bcrypt_pbkdf', '~> 1.1'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'database_cleaner-active_record'
  gem 'launchy'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver', '>= 4.0.0.rc1'
  gem 'shoulda-matchers', '~> 4.0'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
