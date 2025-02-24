# config/puma.rb

# 環境設定
environment ENV.fetch("RAILS_ENV") { "production" }

# PID ファイルは Rails.root の tmp/pids 内に配置
pidfile Rails.root.join("tmp", "pids", "puma.pid")

# ログ出力も Rails.root の log ディレクトリに書き込む
stdout_redirect Rails.root.join("log", "puma.stdout.log"),
                Rails.root.join("log", "puma.stderr.log"),
                true

# ポートは環境変数 PORT（Render から提供される）または 3000 を使用
port ENV.fetch("PORT") { 3000 }

# ワーカーやスレッドの設定（必要に応じて調整してください）
workers ENV.fetch("WEB_CONCURRENCY") { 2 }
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

preload_app!

on_worker_boot do
  # ActiveRecord を使用している場合は、コネクションを確立する
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
