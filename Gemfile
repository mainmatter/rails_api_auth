source 'https://rubygems.org'

gemspec

platforms :ruby, :mswin, :mingw do
  gem 'sqlite3'
end
platforms :jruby do
  gem 'activerecord-jdbcsqlite3-adapter'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'faker'
end

group :development do
  gem 'appraisal'
  gem 'rubocop'
  gem 'guard-rubocop'
  gem 'guard-rspec', require: false
  gem 'guard-bundler', require: false
end

group :test do
  gem 'shoulda'
  gem 'webmock', require: 'webmock/rspec'
  gem 'timecop'
  gem 'json_spec'
  gem 'rails-controller-testing'
  gem 'test-unit'
  gem 'simplecov', require: false
end
