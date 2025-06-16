if ENV["RAILS_ENV"] == "production"
  directory "/home/deploy/transystem/toyohashi"
  bind "unix:///home/deploy/deploy/transystem/toyohashi/tmp/sockets/puma.sock"
  pidfile "/home/deploy/deploy/transystem/toyohashi/tmp/pids/puma.pid"
  state_path "/home/deploy/deploy/transystem/toyohashi/tmp/pids/puma.state"
  stdout_redirect "/home/deploy/deploy/transystem/toyohashi/log/puma.stdout.log", "/home/deploy/deploy/transystem/toyohashi/log/puma.stderr.log", true
else
  port ENV.fetch("PORT") { 3000 }
end

environment ENV.fetch("RAILS_ENV") { "development" }
plugin :tmp_restart
