# config/importmap.rb

# Import the main application JavaScript file
pin "application"

# Import Turbo and Stimulus (if using Hotwire)
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

# Import controllers from app/javascript/controllers
pin_all_from "app/javascript/controllers", under: "controllers"

# Import additional libraries
pin "@rails/actioncable", to: "actioncable.js", preload: true
pin "@rails/ujs", to: "rails-ujs.js", preload: true
