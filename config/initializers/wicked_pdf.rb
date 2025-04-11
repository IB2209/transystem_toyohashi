# config/initializers/wicked_pdf.rb

require 'wicked_pdf'

WickedPdf.config = {
  exe_path: "#{Rails.root}/.apt/usr/local/bin/wkhtmltopdf"
}
