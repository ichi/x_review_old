source 'https://rubygems.org'

# Framework
gem 'rails', '4.2.0'

# DB
gem 'sqlite3'

# Assets
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
# gem 'therubyracer', platforms: :ruby # See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'slim-rails'

# Models
gem 'active_hash'

# Auth
gem 'devise'
gem 'omniauth-twitter'


# Server
gem 'thin'

# Doc
group :doc do
  gem 'sdoc', require: false
end

# Debug
group :development, :test do
  # gem 'byebug'
  gem 'web-console', '~> 2.0'

  gem 'pry-rails'
  gem 'pry-doc'
  gem 'pry-stack_explorer'
  gem 'tapp-awesome_print'
end

# Debug
group :development do
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'quiet_assets'
  gem 'what_methods'
  gem 'bullet'
  gem 'letter_opener'
  gem 'brakeman', require: false
  gem "better_errors"
  gem "binding_of_caller"
end

# TDD
group :test do
  gem 'rspec-rails', '~> 3.0', group: :development
  gem 'rspec-its'
  gem 'shoulda-matchers', require: false
  gem 'fuubar'
  gem 'factory_girl_rails', group: :development
  gem 'faker', group: :development
  gem 'guard-rspec', require: false
  gem 'database_rewinder'
end
