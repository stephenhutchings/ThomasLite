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

    # set every bar to an equal value based on number of bars
    @equalizeBars()
    @createDraggy()

  # before the user can drag each bar, set each bar's value to 100%/# of bars
  equalizeBars: ->
    barCount = @getEl("bars").length
    barDecimal = 1 / barCount
    barPercent = Math.floor(barDecimal * 100)
    console.log(barPercent)

    for el, i in @getEl("bars")
      bar = el.querySelector(".ratio_bar")

      @transformEl bar,
        scale: "#{barDecimal}, 1"

      value = el.querySelector(".ratio_value_amount")
      value.innerHTML = barPercent + "%"




  # Create a "draggies" array of each "draggy" ratio bar
  createDraggy: ->
    @draggies = []

    # for every "bars" element on the page, as "i"
    for el, i in @getEl("bars")
      draggy = new Draggy
        el: el
        isParent: true
        # set the x parameters as the left and right sides of "i"
        minX: 0
        maxX: el.offsetWidth

      @listenTo draggy, "drag", @onDrag
      @listenTo draggy, "drop", @onDrop

      @draggies[i] = draggy

  onDrag: (draggy, isInitial) ->
    # set "bar" by treating the draggy as an element then query selecting
    # the ".ratio_bar" within it
    bar = draggy.el.querySelector(".ratio_bar")
    x = draggy.x
    percentage = Math.max(Math.min(draggy.x / draggy.offset.width, 1), 0)

    # apply a transform to "bar," setting the x-scale to the percentage value
    @transformEl bar,
      scale: "#{percentage}, 1"

    @setBarLabel(percentage, draggy)

  setBarLabel: (percentage, draggy) ->
    percentage = Math.round(percentage * 100)
    value = draggy.el.querySelector(".ratio_value_amount")
    value.innerHTML = percentage + "%"

  events: ->
    "iostap .btn-next": "next"
    "iostap .btn-exit": "exit"


module.exports = RatioView
