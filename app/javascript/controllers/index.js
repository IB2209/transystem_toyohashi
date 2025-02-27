// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { Application } from "@hotwired/stimulus";
import { definitionsFromContext } from "@hotwired/stimulus";

const application = Application.start();
const context = require.context(".", true, /\.js$/);
application.load(definitionsFromContext(context));

eagerLoadControllersFrom("controllers", application)
