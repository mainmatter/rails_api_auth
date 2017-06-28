source 'https://rubygems.org'

gemspec

platforms :ruby, :mswin, :mingw do
  gem 'sqlite3'
end
platforms :jruby do
  gem 'activerecord-jdbcsqlite3-adapter'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'rspec-rails'
end

group :development do
  gem 'appraisal'
  gem 'guard-bundler', require: false
  gem 'guard-rspec', require: false
  gem 'guard-rubocop'
  gem 'rubocop'
end

group :test do
  gem 'json_spec'
  gem 'rails-controller-testing'
  gem 'shoulda'
  gem 'simplecov', require: false
  gem 'test-unit'
  gem 'timecop'
  gem 'webmock', require: 'webmock/rspec'
end
