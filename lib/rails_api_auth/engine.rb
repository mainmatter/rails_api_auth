module RailsApiAuth

  class Engine < ::Rails::Engine

    config.generators do |g|
      g.test_framework :rspec
    end

  end

end
