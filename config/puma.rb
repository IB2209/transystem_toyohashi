if ENV["RAILS_ENV"] == "production"
  directory "/home/deploy/transystem_toyohashi"
  bind "unix:///home/deploy/transystem_toyohashi/tmp/sockets/puma.sock"
  pidfile "/home/deploy/transystem_toyohashi/tmp/pids/puma.pid"
  state_path "/home/deploy/transystem_toyohashi/tmp/pids/puma.state"
  stdout_redirect "/home/deploy/transystem_toyohashi/log/puma.stdout.log", "/home/deploy/transystem_toyohashi/log/puma.stderr.log", true
else
  port ENV.fetch("PORT") { 3000 }
end

environment ENV.fetch("RAILS_ENV") { "development" }
plugin :tmp_restart
