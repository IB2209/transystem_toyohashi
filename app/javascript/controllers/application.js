import { Application } from "@hotwired/stimulus";
import { definitionsFromContext } from "@hotwired/stimulus";


const application = Application.start();
const context = require.context("controllers", true, /\.js$/);
application.load(definitionsFromContext(context));