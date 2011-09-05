require 'test_helper'
require 'sprockets'

class AssetPathsTest < ActionView::TestCase
  tests Sprockets::Helpers::RailsHelper

  attr_accessor :assets

  def setup
    super

    @controller = BasicController.new

    @request = Class.new do
      def protocol() 'http://' end
      def ssl?() false end
      def host_with_port() 'localhost' end
    end.new

    @controller.request = @request

    @assets = Sprockets::Environment.new
    @assets.append_path(FIXTURES.join("images"))

    application = Struct.new(:config, :assets).new(config, @assets)
    Rails.stubs(:application).returns(application)
    @config = config
    @config.action_controller ||= ActiveSupport::InheritableOptions.new
    @config.perform_caching = true
    @config.assets.digest = true
    @config.assets.digest_exclusions = []
    @config.assets.compile = true
  end

  def url_for(*args)
    "http://www.example.com"
  end
  
  test "sanity check" do
    assert_match %r{/assets/logo-[0-9a-f]+.png}, asset_path("logo.png")
  end
  
  test "digest disabled" do
    @config.assets.digest = false
    assert_equal "/assets/logo.png", asset_path("logo.png")
  end
  
  test "digest excluded by exact match" do
    @config.assets.digest_exclusions << "logo.png"
    assert_equal "/assets/logo.png", asset_path("logo.png")
  end
  
  test "digest excluded by glob" do
    @config.assets.digest_exclusions << "logo.*"
    assert_equal "/assets/logo.png", asset_path("logo.png")
  end
  
  test "digest excluded by regex" do
    @config.assets.digest_exclusions << /logo/
    assert_equal "/assets/logo.png", asset_path("logo.png")
  end
end
