#!/usr/bin/env bash
set -o errexit

echo "📦 Installing wkhtmltopdf..."

mkdir -p .apt
curl -L https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.6/wkhtmltox_0.12.6-1.bionic_amd64.deb -o wkhtmltopdf.deb
dpkg -x wkhtmltopdf.deb .apt
rm wkhtmltopdf.deb

echo "📦 Installing Ruby dependencies..."

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# DBマイグレーション（必要に応じて）
# bundle exec rails db:migrate
