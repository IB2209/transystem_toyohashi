# Rails.application.config.assets.version は、アセットの変更を認識させるためのもの
Rails.application.config.assets.version = "1.0"

# 個別のアセットをプリコンパイル対象に追加
Rails.application.config.assets.precompile += %w( script.js movement_records.js )
