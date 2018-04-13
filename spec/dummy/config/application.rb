require File.expand_path('boot', __dir__)

require 'active_record/railtie'
require 'action_controller/railtie'
require 'sprockets/railtie'

Bundler.require(*Rails.groups)

require 'rails_api_auth'

module Dummy

  class Application < Rails::Application

  end

end
