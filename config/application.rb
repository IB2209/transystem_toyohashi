require_relative "boot"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
require "rails/all"
require "sprockets/railtie" # Sprockets を明示的に読み込む
require "importmap-rails"



module DispatchApp
  class Application < Rails::Application
    config.load_defaults 7.2
    config.i18n.default_locale = :ja
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    # サブディレクトリ対応（★この行を追加）
    config.relative_url_root = "/coxgear/transystem/toyohashi"

    # 不要なlibフォルダのオートロードを無視
    config.autoload_lib(ignore: %w[assets tasks])
  end
end

