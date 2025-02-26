# config/importmap.rb

# Import the main application JavaScript file
pin "application"

# Import Turbo and Stimulus (if using Hotwire)
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"


# Import controllers from app/javascript/controllers
pin_all_from "app/javascript/controllers", under: "controllers"
