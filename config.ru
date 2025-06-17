# This file is used by Rack-based servers to start the application.
ENV['RAILS_RELATIVE_URL_ROOT'] = "/coxgear/transystem/toyohashi"

require_relative "config/environment"

run Rails.application
Rails.application.load_server
