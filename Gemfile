source 'https://rubygems.org'
ruby '2.3.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'

gem 'activeadmin', '~> 1.0.0.pre4'
gem 'carrierwave', '~> 0.11.2'
gem 'carrierwave-base64', '~> 2.6.1'
gem 'delayed_job_active_record', '~> 4.1.1'
gem 'devise', '~> 4.2.0'
gem 'devise_token_auth', '~> 0.1.39'
gem 'draper', '~> 3.0.0.pre'
gem 'fog-aws', '~> 0.12.0'
gem 'haml', '~> 4.0.6'
gem 'inherited_resources', github: 'activeadmin/inherited_resources'
gem 'jbuilder', '~> 2.6.1'
gem 'oj', '~> 2.17.5'
gem 'koala', '~> 1.10.1'
gem 'pg', '~> 0.18.2'
gem 'pry-rails', '~> 0.3.4'
gem 'puma', '~> 3.0'
gem 'rack-cors', '~> 0.4.0'
gem 'sendgrid', '~> 1.2.4'
gem 'mini_magick', '~> 4.3.3'                  # Resize images
gem 'kaminari', '~> 0.17.0'                    # Pagination
gem 'activerecord-postgis-adapter', '~> 4.0.4' # Adapter to support postgis extension for postgres
gem 'one_signal', '~> 1.2.0'
gem 'sprockets', '~>3.7.2'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'faker', '~> 1.7.3'
  gem 'pry-byebug', '~> 3.3.0', platform: :mri
  gem 'rails-controller-testing', '~> 1.0.1'
  gem 'rspec-rails', '~> 3.5.2'
  gem 'rspec-core', '~> 3.5.2'
  gem 'json_matchers', '~> 0.7.0'
end

group :development do
  gem 'annotate', '~> 2.6.5'
  gem 'better_errors', '~> 2.1.1'
  gem 'binding_of_caller', '~> 0.7.2'
  gem 'brakeman', '~> 3.4.0'
  gem 'letter_opener', '~> 1.4.1'
  gem 'listen', '~> 3.0.5'
  gem 'rails_best_practices', '~> 1.16.0'
  gem 'reek', '~> 3.4.0'
  gem 'rubocop', '~> 0.32.1'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'database_cleaner', '~> 1.4.1'
  gem 'shoulda-matchers', '~> 3.1.1'
  gem 'simplecov', '~> 0.13.0', require: false
  gem 'webmock', '~> 2.3.2'
end

group :assets do
  gem 'uglifier', '~> 2.7.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
