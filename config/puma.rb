# Puma のスレッド設定
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

# Puma をデーモン化（バックグラウンドで実行）
daemonize true

# ポート番号の指定（Nginx からのリクエストを受ける）
bind "unix:///var/www/movement_records/tmp/sockets/puma.sock"

# Puma のプロセス ID ファイル
pidfile "/var/www/movement_records/tmp/pids/puma.pid"

# Puma のログ
stdout_redirect "/var/www/movement_records/log/puma.stdout.log", "/var/www/movement_records/log/puma.stderr.log", true

# workers 数（CPU のコア数に合わせる）
workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# プリロードモード（メモリ効率を向上）
preload_app!
