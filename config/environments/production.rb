require "active_support/core_ext/integer/time"

Rails.application.configure do
  # クラスキャッシュは本番環境では有効（デフォルト）
  config.cache_classes = true

  # ブート時にコードを eager load してパフォーマンス向上（Rake タスク以外）
  config.eager_load = true

  # フルエラーレポートは無効にし、ユーザーにはカスタムエラーページを表示
  config.consider_all_requests_local = false

  # フラグメントキャッシュなど、キャッシングを有効化
  config.perform_caching = true

  # 静的ファイルはキャッシュヘッダーを付与して配信
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.year.to_i}"
  }

  # Active Storage の設定（必要なら、config/storage.yml と連携）
  # 例: 環境変数 ACTIVE_STORAGE_SERVICE に 'amazon' や 'local' などを設定
  # config.active_storage.service = ENV.fetch("ACTIVE_STORAGE_SERVICE", "local").to_sym

  # SSL ターミネーションを前提とした設定
  config.assume_ssl = true
  config.force_ssl = true
  # （必要に応じて ssl_options を追加できます）
  # config.ssl_options = { redirect: { exclude: ->(request) { request.path == "/up" } } }

  # ログの設定：リクエストIDをタグに付与し、STDOUT に出力
  config.log_tags = [:request_id]
  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # ログレベルは環境変数で柔軟に設定（デフォルトは info）
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info").to_sym

  # ヘルスチェックのログを抑制（例: /up へのリクエスト）
  config.silence_healthcheck_path = "/up"

  # 非推奨（deprecation）の報告は無効化
  config.active_support.report_deprecations = false

  # Action Mailer の設定。リンク生成用のホストは環境変数から取得
  config.action_mailer.default_url_options = { host: ENV.fetch("DOMAIN", "example.com") }
  # SMTP の設定は必要に応じて有効化（例: SendGrid や Mailgun の場合）
  # config.action_mailer.smtp_settings = {
  #   user_name: Rails.application.credentials.dig(:smtp, :user_name),
  #   password: Rails.application.credentials.dig(:smtp, :password),
  #   address: "smtp.example.com",
  #   port: 587,
  #   authentication: :plain
  # }

  # I18n のフォールバックを有効にし、翻訳が見つからない場合はデフォルトロケールに戻す
  config.i18n.fallbacks = true

  # マイグレーション後にスキーマダンプを行わない（パフォーマンス向上）
  config.active_record.dump_schema_after_migration = false

  # 本番環境でのデバッグ情報として、Active Record の inspection は :id のみ表示
  config.active_record.attributes_for_inspect = [:id]

  # DNS リバインディング攻撃対策や Host ヘッダーの制限（必要なら有効化）
  # config.hosts = ["example.com", /.*\.example\.com/]
  # config.host_authorization = { exclude: ->(request) { request.path == "/up" } }
end
