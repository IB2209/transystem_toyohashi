# Puma のスレッド設定
threads_count = ENV.fetch("RAILS_MAX_THREADS", 5)
threads threads_count, threads_count

# 必要なディレクトリを作成
directory "/var/www/movement_records"
FileUtils.mkdir_p("/var/www/movement_records/tmp/sockets")
FileUtils.mkdir_p("/var/www/movement_records/tmp/pids")
FileUtils.mkdir_p("/var/www/movement_records/log")

# Puma のプロセス ID ファイル
pidfile "/var/www/movement_records/tmp/pids/puma.pid"

# ソケットファイルの設定
bind "unix:///var/www/movement_records/tmp/sockets/puma.sock"

# ソケットファイルの権限変更（nginx からのアクセスを許可）
on_worker_boot do
  FileUtils.chmod(0777, "/var/www/movement_records/tmp/sockets/puma.sock") if File.exist?("/var/www/movement_records/tmp/sockets/puma.sock")
end

# workers 数（CPU のコア数に合わせる）
workers ENV.fetch("WEB_CONCURRENCY", 1)

# プリロードモード（メモリ効率を向上）
preload_app!

# Puma のログ
stdout_redirect "/var/www/movement_records/log/puma.stdout.log", "/var/www/movement_records/log/puma.stderr.log", true

# production.log へのリダイレクト
log_path = "/var/www/movement_records/log/production.log"
stdout_redirect log_path, log_path, true

# 再起動時にソケットファイルを削除
on_restart do
  FileUtils.rm_f("/var/www/movement_records/tmp/sockets/puma.sock")
end
