#!/usr/bin/env bash
set -o errexit

echo "📦 Installing wkhtmltopdf..."

# 正しいURLからダウンロードして保存
curl -L -o wkhtmltopdf.deb https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.6/wkhtmltox_0.12.6-1.bionic_amd64.deb

# ファイルサイズ確認（20MB程度が正常）
ls -lh wkhtmltopdf.deb

# Renderのbuild環境が制限されてるため、dpkg -x（展開のみ）を使う
mkdir -p .apt
dpkg -x wkhtmltopdf.deb .apt
rm wkhtmltopdf.deb

# PATH設定（これ重要）
export PATH="$PWD/.apt/usr/local/bin:$PATH"

echo "📦 Installing Ruby dependencies..."
bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
