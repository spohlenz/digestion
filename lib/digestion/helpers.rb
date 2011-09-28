require 'sprockets/helpers'

Sprockets::Helpers::RailsHelper.module_eval do
  alias_method :original_asset_paths, :asset_paths
  
  def asset_paths
    @asset_paths ||= original_asset_paths.tap do |paths|
      paths.digest_assets     = digest_assets?
      paths.digest_exclusions = digest_exclusions
    end
  end

private
  remove_method(:digest_assets?) if private_method_defined?(:digest_assets?)
  def digest_assets?
    Rails.application.config.assets.digest
  end
  
  def digest_exclusions
    Rails.application.config.assets.digest_exclusions
  end
end

Sprockets::Helpers::RailsHelper::AssetPaths.class_eval do
  attr_accessor :digest_assets unless method_defined?(:digest_assets)
  attr_accessor :digest_exclusions
  
  alias_method :original_digest_for, :digest_for
  
  def digest_for(logical_path)
    if digest_path?(logical_path)
      original_digest_for(logical_path)
    else
      logical_path
    end
  end

private
  def digest_path?(logical_path)
    return false unless digest_assets
    return true if digest_exclusions.blank?
    
    digest_exclusions.none? do |path|
      if path.is_a?(Regexp)
        # Match path against `Regexp`
        path.match(logical_path)
      else
        # Otherwise use fnmatch glob syntax
        File.fnmatch(path.to_s, logical_path)
      end
    end
  end
end
