# Import the main application JavaScript file
pin "application"

# Import Turbo and Stimulus (if using Hotwire)
pin "@hotwired/turbo-rails", to: "@hotwired--turbo-rails.js", preload: true
pin "@hotwired/stimulus", to: "vendor/javascript/@hotwired--stimulus.js", preload: true
pin "@hotwired/stimulus-loading", to: "vendor/javascript/stimulus-loading.js", preload: true

# Import controllers from app/javascript/controllers
pin_all_from "app/javascript/controllers", under: "controllers"

# Import additional libraries
pin "@rails/actioncable", to: "@rails--actioncable--src.js", preload: true
pin "@rails/ujs", to: "rails-ujs.js", preload: true

# Import vendor JavaScript
pin_all_from "vendor/javascript", under: "vendor"
