SlideView = require("views/slide")
Prefix = require("lib/prefix")
Draggy = require("views/components/draggy")

class RatioView extends SlideView
  template: require("./template")

  # If your view has post-rendering logic that requires elements to be visible
  # in order to instantiate them properly, this is the place to do it.
  afterShow: ->
    return if @draggy

    @setEl @el.querySelectorAll(".ratio"), "bars"
    @setEl @el.querySelectorAll(".ratio_bar"), "bar_fills"

    @createDraggy()

  # Create a new "draggy" with radius, and listen to it's drag and drop events.
  createDraggy: ->
    @draggies = []

    for el, i in @getEl("bars")
      draggy = new Draggy
        el: el
        isParent: true
        minX: 0
        maxX: el.offsetWidth

      @listenTo draggy, "drag", @onDrag
      @listenTo draggy, "drop", @onDrop

      @draggies[i] = draggy

  # The user has dragged their finger on the screen. "isInitial" is true for
  # the first touch only.
  onDrag: (draggy, isInitial) ->
    bar = draggy.el.querySelector(".ratio_bar")
    x = draggy.x
    percentage = Math.max(Math.min(draggy.x / draggy.offset.width, 1), 0)

    @transformEl bar,
      scale: "#{percentage}, 1"

    # @setBarLabel(percentage)

  # setBarLabel: (percentage) ->
  #   console.log "#{Math.round(percentage * 100)}%"
  #   value = draggy.el.querySelector


  events: ->
    "iostap .btn-next": "next"
    "iostap .btn-exit": "exit"


module.exports = RatioView
