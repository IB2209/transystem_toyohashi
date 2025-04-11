#!/usr/bin/env bash
# exit on error
set -o errexit

echo "Installing wkhtmltopdf..."
curl -LO https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.6/wkhtmltox_0.12.6-1.bionic_amd64.deb
apt update
apt install -y ./wkhtmltox_0.12.6-1.bionic_amd64.deb

echo "Installing dependencies..."

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean


# If you're using a Free instance type, you need to
# perform database migrations in the build command.
# Uncomment the following line:

# bundle exec rails db:migrate