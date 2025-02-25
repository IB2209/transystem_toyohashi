require_relative "boot"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
require "rails/all"
require "sprockets/railtie" # Sprockets を明示的に読み込む

module DispatchApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2
    config.i18n.default_locale = :ja

    # `lib/` 以下の不要なフォルダをオートロードしない
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
