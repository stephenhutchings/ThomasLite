SlideView = require("views/slide")
Prefix = require("lib/prefix")
Draggy = require("views/components/draggy")

class RatioView extends SlideView
  template: require("./template")

  events:
    "iostap .btn-done": "showAnswer"

  # If your view has post-rendering logic that requires elements to be visible
  # in order to instantiate them properly, this is the place to do it.
  afterShow: ->
    return if @draggies

    @listenTo this, "resize", @onResize

    @setEl @el.querySelectorAll(".ratio"), "bars"
    @createDraggies()

  onRefresh: ->
    for draggy in @draggies or []
      draggy.undelegateEvents()

    @draggies = null
    @afterShow()

  onResize: ->
    return unless @draggies?.length > 0

    window.clearTimeout @timeout
    @timeout = window.setTimeout (=>
      if @currentState.state is "prompt"
        totalWidth = @getEl("bars").item(0).offsetWidth
        initialX   = totalWidth / @getEl("bars").length

      for draggy, i in @draggies
        draggy.getOffset()
        draggy.options.maxX = draggy.offset.totalWidth
        draggy.reset(x: initialX) if initialX
    ), 600

  # Ensure "total" and "increment" are rational numbers.
  serialize: ->
    data = super

    { total, increment } = data.ratio

    data.ratio.total     = parseFloat(total, 10) or 100
    data.ratio.increment = parseFloat(increment, 10) or 1
    data.ratio.bars = _.filter data.ratio.bars, (b) -> b.title and b.value

    data

  # Create a "draggies" array of each "draggy" ratio bar. Save a reference to
  # the bar and value element of each draggy in it's options, for quick access
  # later on.
  createDraggies: ->
    totalWidth = @getEl("bars").item(0).offsetWidth or @serialize().width
    initialX   = totalWidth / @getEl("bars").length

    @draggies =
      for el in @getEl("bars")
        draggy = new Draggy
          el: el
          minX: 0
          maxX: totalWidth
          isParent: true
          barElement: el.querySelector(".ratio-bar")
          valElement: el.querySelector(".ratio-value-amount")

        @listenTo draggy, "drag", @onDrag
        @listenTo draggy, "drop", @onDrop

        draggy.reset x: initialX, y: 0
        draggy

  onDrag: (draggy, isInitial) ->
    @currentDraggy = draggy
    @setState("touched")
    @renderDraggy(draggy, isInitial)
    @updateDraggies(draggy, isInitial)

  onDrop: (draggy, isReset) ->
    if isReset
      @renderDraggy(draggy, true)
    else
      @snapBars()

  # To ensure that "zeroed-out" draggies can still contribute to the overall
  # distribution, we ensure that it is above zero.
  getPercent: (draggy) ->
    Math.max(Math.min((draggy.x / draggy.offset.width) or 0, 1), 0.0001)

  getLabel: (draggy) ->
    { prefix, suffix } = @options.data.ratio

    "#{prefix}#{@getValue(draggy)}#{suffix}"

  getValue: (draggy) ->
    { total, increment } = @options.data.ratio

    percent = @getPercent(draggy)
    Math.round(total * percent / increment) * increment

  # Transform the draggy bar and display the current value in the draggy label.
  renderDraggy: (draggy, transition) ->
    @transformEl draggy.options.barElement,
      scale: "#{@getPercent(draggy)}, 1"
      transition: if transition then "all 300ms" else ""

    draggy.options.valElement.innerHTML = @getLabel(draggy)

  # For each draggy except the current one, we need to redistribute the
  # remaining percentage. To do this, we:
  # 1. Calculate the remainder to distribute
  # 2. Calculate the total value of other draggies
  # 3. For each draggy, distribute the remainder based on it's previous
  #    proportion of the current total.
  # 4. Reset the draggy based on this new value.
  updateDraggies: (draggy, transition) ->
    remainder     = 1 - @getPercent(draggy)
    otherDraggies = _.filter(@draggies, (d) -> d isnt draggy)
    currentTotal  = _.reduce otherDraggies, ((m, d) => m + @getPercent(d)), 0

    for otherDraggy, i in otherDraggies
      current = @getPercent(otherDraggy)
      percent = current / currentTotal * remainder
      x       = percent * otherDraggy.offset.width

      otherDraggy.reset { x }, silent: true
      @renderDraggy(otherDraggy, transition)

  # When we finish dragging, we need to ensure the subtotal value from each
  # bar matches the expected total. To acheive this, we simply snap each
  # bar into place and add/remove any remaining excess from the last draggy.
  snapBars: ->
    subtotal  = 0
    { total } = @options.data.ratio

    for draggy, i in @draggies
      value = @getValue(draggy)
      subtotal += value

      if i is @draggies.length - 1
        value -= (subtotal - total)

      x = Math.floor(value / total * draggy.offset.width)

      draggy.reset { x }

  # Check that the user is correct by asserting for every bar in the data
  # that the input value matches.
  isCorrect: ->
    _.chain(@options.data.ratio.bars)
      .filter((b, i) => b.value isnt @getValue(@draggies[i]))
      .isEmpty()
      .value()

  showAnswer: ->
    super

    { bars, total } = @options.data.ratio

    for { value }, i in bars
      draggy    = @draggies[i]
      isCorrect = @getValue(draggy) is value

      draggy.el.parentNode.classList.toggle "correct", isCorrect
      draggy.el.parentNode.classList.toggle "incorrect", not isCorrect
      draggy.reset x: draggy.offset.width * value / total

module.exports = RatioView
