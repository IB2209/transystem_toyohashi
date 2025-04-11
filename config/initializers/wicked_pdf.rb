# config/initializers/wicked_pdf.rb

require 'wicked_pdf'


# config/initializers/wicked_pdf.rb
WickedPdf.config = {
  exe_path: "#{Rails.root}/.apt/usr/local/bin/wkhtmltopdf"
}
