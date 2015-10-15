module RailsApiAuth

  # @!visibility private
  class Engine < ::Rails::Engine

    engine_name 'rails_api_auth'

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths['db/migrate'].expanded.each do |expanded_path|
          app.config.paths['db/migrate'] << expanded_path
        end
      end
    end

  end

end
