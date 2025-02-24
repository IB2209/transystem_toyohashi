# Be sure to restart your server when you modify this file.



if Rails.application.config.respond_to?(:assets)
  Rails.application.config.assets.version = '1.0'
  Rails.application.config.asset_host = ENV['ASSET_HOST'] if ENV['ASSET_HOST'].present?
end


# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
