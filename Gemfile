source 'https://rubygems.org'

#ruby '2.2.0'
gem 'rails', '4.2.0'			 # Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'sass-rails'
gem 'uglifier', '>= 1.3.0'		 # Use Uglifier as compressor for JavaScript assets
gem 'coffee-rails', '~> 4.1.0'	 # Use CoffeeScript for .coffee assets and views
gem 'mongoid', "~> 4.0.0"
# gem 'therubyracer', platforms: :ruby # See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'bootstrap-sass', '~> 3.2.0'
gem 'autoprefixer-rails'

gem 'haml'
gem 'font-awesome-sass'

gem 'haml-rails'
gem 'mailgun-ruby', '~> 1.0.2', require: 'mailgun'
gem 'twilio-ruby', '~> 4.0.0'
gem 'figaro'
gem 'recaptcha', require: 'recaptcha/rails'

gem 'jquery-rails'				 # Use jquery as the JavaScript library
gem 'jquery-turbolinks'
gem 'turbolinks'				 # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'jbuilder', '~> 2.0'		 # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'sdoc', '~> 0.4.0', group: :doc # bundle exec rake doc:rails generates the API under doc/api.

gem 'bcrypt', '~> 3.1.7'		 # Use ActiveModel has_secure_password
gem 'geokit-rails', '~> 2.1.0'   # Geokit for address/GPS coor transformation 
								 # https://github.com/geokit/geokit-rails
gem 'mongoid-geospatial', '~>4.0'	# Mongoid Geospatial
									# https://github.com/nofxx/mongoid-geospatial


gem 'simple_form'
gem 'fabrication'
gem 'faker'

# gem 'unicorn' # Use Unicorn as the app server

# gem 'capistrano-rails', group: :development # Use Capistrano for deployment

group :development, :test do
  gem 'byebug'					 # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'web-console', '~> 2.0'	 # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'spring'					 # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'database_cleaner'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'site_prism'

  gem 'guard'
  gem 'guard-livereload', '~> 2.4', require: false
  gem "rack-livereload", :group => :development
  gem 'guard-rspec', require: false

end


group :production do
  gem 'rails_12factor', '0.0.2'
  gem 'puma',           '2.11.1'
end
