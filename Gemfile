source 'https://rubygems.org'

gemspec

group :development do
  platforms :ruby, :mswin, :mingw do
    gem 'sqlite3'
  end
  platforms :jruby do
    gem 'jdbc-sqlite3'
    gem 'activerecord-jdbc-adapter'
  end

  gem 'guard-rubocop'
  gem 'guard-rspec', require: false
  gem 'guard-bundler', require: false
  gem 'factory_girl_rails'
end

group :test do
  gem 'rspec-rails'
  gem 'shoulda'
  gem 'webmock', require: 'webmock/rspec'
  gem 'timecop'
  gem 'json_spec'
end
