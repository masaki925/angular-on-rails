source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.1'
ruby '2.0.0'

gem 'rails-api'

# Use mysql as the database for Active Record
gem 'mysql2'


# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
gem 'jbuilder'

# Use unicorn as the app server
gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano', :group => :development

# To use debugger
gem 'debugger', group: [:development, :test]


#///////////////////////////////
# Wanderlust

# login with facebook/twitter/...
gem 'sorcery'

# Facebook API
gem 'fb_graph'

# Foursquare API
gem 'foursquare2'

group :test, :development do
  # for test
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'pry-remote'
  gem 'pry-debugger'

  # test server
  gem 'spork', '~> 1.0rc'

  # Rails application preloader
  gem 'spring'

  # show coverage of test
  gem 'simplecov'
end

group :production do
  # monitoring
  gem 'newrelic_rpm'
end

# read environment variable from config/application.yml
gem 'figaro'

# emphasis strong parameter error
gem 'colorize_unpermitted_parameters'

