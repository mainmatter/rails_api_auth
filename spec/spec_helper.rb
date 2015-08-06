ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start do ||
  minimum_coverage 95
  refuse_coverage_drop
end

require File.expand_path('../dummy/config/environment.rb', __FILE__)
require 'rspec/rails'
require 'factory_girl_rails'
require 'faker'

Rails.backtrace_cleaner.remove_silencers!

%w(factories support).each do |path|
  Dir["#{File.dirname(__FILE__)}/#{path}/**/*.rb"].each { |f| require f }
end

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!
  config.order = 'random'
end
