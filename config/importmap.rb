# Import the main application JavaScript file
pin "application"

# Import Turbo and Stimulus (if using Hotwire)
pin "@hotwired/turbo-rails", to: "@hotwired--turbo-rails.js" # @8.0.12
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@hotwired/turbo", to: "@hotwired--turbo.js" # @8.0.12

# Import controllers from app/javascript/controllers
pin_all_from "app/javascript/controllers", under: "controllers"

# Import additional libraries
pin "@rails/actioncable", to: "@rails--actioncable.js" # @8.0.100
pin "@rails/ujs", to: "@rails--ujs.js" # @7.1.3

# Import vendor JavaScript
pin_all_from "vendor/javascript", under: "vendor"
pin "@rails/actioncable/src", to: "@rails--actioncable--src.js" # @7.2.201
