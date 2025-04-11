#!/usr/bin/env bash
set -o errexit

echo "📦 Installing wkhtmltopdf..."

# 安定したダウンロード
curl -L -A "Mozilla/5.0" -o wkhtmltopdf.deb https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.6/wkhtmltox_0.12.6-1.bionic_amd64.deb

# デバッグ用ファイルサイズ出力
ls -lh wkhtmltopdf.deb

# dpkg 展開のみで .apt にバイナリ配置
mkdir -p .apt
dpkg -x wkhtmltopdf.deb .apt
rm wkhtmltopdf.deb

export PATH="$PWD/.apt/usr/local/bin:$PATH"

echo "📦 Installing Ruby dependencies..."
bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
