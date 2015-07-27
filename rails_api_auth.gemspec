$:.push File.expand_path("../lib", __FILE__)

require 'rails_api_auth/version'

Gem::Specification.new do |s|
  s.name        = 'rails_api_auth'
  s.version     = RailsApiAuth::VERSION
  s.authors     = ['Marco Otte-Witte', 'Oliver Barnes']
  s.email       = ['marco.otte-witte@simplabs.com']
  s.homepage    = 'https://github.com/simplabs/rails-api-auth'
  s.summary     = 'Engine that implements OAuth 2.0 and Facebook authentication for API projects'
  s.description = 'Rails API Auth is a Rails Engine that implements the "Resource Owner Password Credentials Grant" OAuth 2.0 flow as well as Facebook authentication for API projects.'
  s.license     = 'MIT'

  s.files      = Dir['{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency('rails', '>= 3.2.6', '< 5')
  s.add_dependency('bcrypt', '~> 3.1.7')
  s.add_dependency('httparty', '~> 0.13.3')
  s.add_dependency('email_validator', '~> 1.6.0')

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'faker'
end
