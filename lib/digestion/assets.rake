Rake::Task["assets:precompile"].clear

def digest_path?(logical_path)
  return false unless Rails.application.config.assets.digest
  return true if Rails.application.config.assets.digest_exclusions.blank?
  
  Rails.application.config.assets.digest_exclusions.none? do |path|
    if path.is_a?(Regexp)
      # Match path against `Regexp`
      path.match(logical_path)
    else
      # Otherwise use fnmatch glob syntax
      File.fnmatch(path.to_s, logical_path)
    end
  end
end

namespace :assets do
  task :precompile do
    # We need to do this dance because RAILS_GROUPS is used
    # too early in the boot process and changing here is already too late.
    if ENV["RAILS_GROUPS"].to_s.empty? || ENV["RAILS_ENV"].to_s.empty?
      ENV["RAILS_GROUPS"] ||= "assets"
      ENV["RAILS_ENV"]    ||= "production"
      Kernel.exec $0, *ARGV
    else
      Rake::Task["environment"].invoke

      # Ensure that action view is loaded and the appropriate sprockets hooks get executed
      ActionView::Base

      # Always compile files
      Rails.application.config.assets.compile = true

      config = Rails.application.config
      env    = Rails.application.assets
      target = Pathname.new(File.join(Rails.public_path, config.assets.prefix))
      manifest = {}
      manifest_path = config.assets.manifest || target

      config.assets.precompile.each do |path|
        env.each_logical_path do |logical_path|
          if path.is_a?(Regexp)
            next unless path.match(logical_path)
          else
            next unless File.fnmatch(path.to_s, logical_path)
          end

          if asset = env.find_asset(logical_path)
            asset_path = digest_path?(logical_path) ? asset.digest_path : logical_path
            manifest[logical_path] = asset_path
            filename = target.join(asset_path)

            mkdir_p filename.dirname
            asset.write_to(filename)
            asset.write_to("#{filename}.gz") if filename.to_s =~ /\.(css|js)$/
          end
        end
      end

      File.open("#{manifest_path}/manifest.yml", 'w') do |f|
        YAML.dump(manifest, f)
      end
    end
  end
end
