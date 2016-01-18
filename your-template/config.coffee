_ = require("underscore")

isApp    = /^app/
isVendor = /^(vendor|bower_components)/

exports.config =
  plugins:

    afterBrunch: [
      "coffee utils/create-example-config.coffee"
    ]

    autoprefixer:
      browsers: ["iOS 7", "iOS 8", "> 1%", "Firefox > 20"]

    autoReload:
      delay: 300

    jade:
      options:
        noRuntime: true
        globals: ["_", "moment", "typogr", "Big"]

  paths:
    public: "build"

  files:
    javascripts:
      joinTo:
        "js/lite.js": isApp
        "js/lite-vendor.js": isVendor

    stylesheets:
      joinTo: "css/app.css": /\.sass/

    templates:
      defaultExtension: "jade"
      joinTo: "js/lite.js": isApp

  framework: "backbone"
