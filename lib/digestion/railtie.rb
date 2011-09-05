require 'sprockets/railtie'

module Digestion
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load "digestion/assets.rake"
    end
    
    initializer :setup_configuration, :before => :load_environment_config do |app|
      app.config.assets.digest_exclusions = []
    end
  end
end
