# config/initializers/wicked_pdf.rb

require 'wicked_pdf'

WickedPdf.config = {
  exe_path: if Rails.env.production?
              # 本番（Render）環境で wkhtmltopdf をこのパスに置いた場合
              '/opt/render/project/.apt/usr/bin/wkhtmltopdf'
            else
              # ローカル環境用（Macなど）
              '/usr/local/bin/wkhtmltopdf'
            end
}
