require File.expand_path('../boot', __FILE__)

require 'active_record/railtie'
require 'action_controller/railtie'

Bundler.require(*Rails.groups)

require 'rails_api_auth'

module Dummy

  class Application < Rails::Application

  end

end
