SlideView = require("views/slide")

class ExitView extends SlideView
  template: require("./template")

  events: ->
    "iostap .btn": "exit"

  show: ->
    Application.publish("event:completed") {}

module.exports = ExitView
