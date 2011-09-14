require 'sprockets/railtie'

module Digestion
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load "digestion/assets.rake"
    end
    
    config.before_configuration do |app|
      # Initialize digest exclusions to an empty array
      app.config.assets.digest_exclusions ||= []
    end
  end
end
