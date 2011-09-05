require 'sprockets/helpers'

Sprockets::Helpers::RailsHelper::AssetPaths.class_eval do
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
end
