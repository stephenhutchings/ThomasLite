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
    @setEl @el.querySelectorAll(".ratio-bar"), "bar-fills"

    # set every bar to an equal value based on number of bars
    @createDraggy()

  # Create a "draggies" array of each "draggy" ratio bar
  createDraggy: ->
    @draggies = []
    totalWidth = @getEl("bars").item(0).offsetWidth
    initialX   = totalWidth * 1 / @getEl("bars").length

    # for every "bars" element on the page, as "i"
    for el, i in @getEl("bars")
      draggy = new Draggy
        el: el
        isParent: true
        # set the x parameters as the left and right sides of "i"
        minX: 0
        maxX: totalWidth

      @listenTo draggy, "drag", @onDrag
      @listenTo draggy, "drop", @onDrop

      draggy.reset x: initialX, y: 0

      @draggies[i] = draggy

  onDrag: (draggy, isInitial) ->
    @setState("touched")

    if @options.data.ratio.quantity == 1
      @updateBar(draggy)
    else if @options.data.ratio.quantity == 2
      @updateBar(draggy)
      @barReactZeroSumSimple(draggy.x / draggy.offset.width, draggy)
    else if @options.data.ratio.quantity > 2
      @updateBar(draggy)
      @barReactZeroSumComplex(draggy.x / draggy.offset.width, draggy)


  onDrop: (draggy, isReset) ->
    if isReset
      @updateBar(draggy)

  updateBar: (draggy) ->
    barDecimal = Math.max(Math.min(draggy.x / draggy.offset.width, 1), 0)
    barPercent = Math.round(barDecimal * 100)

    bar = draggy.el.querySelector(".ratio-bar")
    value = draggy.el.querySelector(".ratio-value-amount")

    @transformEl bar,
      scale: "#{barDecimal}, 1"

    value.innerHTML = barPercent + "%"

  setBarLabel: (percentage, draggy) ->
    percentage = Math.round(percentage * 100)
    value = draggy.el.querySelector(".ratio-value-amount")
    value.innerHTML = percentage + "%"

  barReactZeroSumSimple: (percentage, draggy) ->
    draggyPercent = percentage
    otherDraggies = _.filter(@draggies, (d) -> d isnt draggy)

    for otherDraggy, i in otherDraggies
      x = (1 - percentage) * otherDraggy.offset.width
      otherDraggy.reset x: x, y: 0

  barReactZeroSumComplex: (percentage, draggy) ->
    draggyPercent = percentage
    otherDraggies = _.filter(@draggies, (d) -> d isnt draggy)
    totalDecimal = 0

    for draggy, i in @draggies
      draggyDecimal = Math.max(Math.min(draggy.x / draggy.offset.width, 1), 0)
      totalDecimal += draggyDecimal

    if totalDecimal > 1
      for otherDraggy, i in otherDraggies
        x = otherDraggy.x - (((totalDecimal - 1) / otherDraggies.length) * otherDraggy.offset.width)
        otherDraggy.reset x: x, y: 0

    else if totalDecimal < 1
      for otherDraggy, i in otherDraggies
        x = otherDraggy.x + (((1 - totalDecimal) / otherDraggies.length) * otherDraggy.offset.width)
        otherDraggy.reset x: x, y: 0


  events: ->
    "iostap .btn-next": "next"
    "iostap .btn-exit": "exit"


module.exports = RatioView
