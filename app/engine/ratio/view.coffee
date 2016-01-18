SlideView = require("views/slide")

class RatioView extends SlideView
  template: require("./template")

  events: ->
    "iostap .btn-next": "next"
    "iostap .btn-exit": "exit"

  initialize: ->
  show: ->
  hide: ->
  beforeShow: ->
  beforeHide: ->
  afterShow:  ->

module.exports = RatioView
