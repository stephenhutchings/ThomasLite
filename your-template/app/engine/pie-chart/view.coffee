# SlideView provides a lot of boilerplate, and is the super-class of all slides
# Prefix takes a style attribute and returns it with a vendor-prefix
# DraggyView abstracts dragging and dropping logic and fires useful events
SlideView = require("views/slide")
Prefix = require("lib/prefix")
Draggy = require("views/components/draggy")

class PieChartView extends SlideView
  template: require("./template")

  events:
    "iostap .btn-done": "showAnswer"

  # If your view has post-rendering logic that requires elements to be visible
  # in order to instantiate them properly, this is the place to do it.
  afterShow: ->
    return if @draggy

    @setEl @el.querySelector(".pie"), "pie"
    @setEl @el.querySelector(".pie-ring-input"), "knob-input"
    @setEl @el.querySelector(".pie-ring-value"), "knob-value"
    @setEl @el.querySelector(".pie-ring-answer"), "knob-answer"

    @resetDashOffset(@getEl("knob-input"))
    @resetDashOffset(@getEl("knob-answer"))

    @createDraggy()

  # Create a new "draggy" with radius, and listen to it's drag and drop events.
  createDraggy: ->
    @draggy = new Draggy
      el: @getEl("pie")
      radius: @getEl("pie").offsetWidth / 2
      isParent: true

    @listenTo @draggy, "drag", @onDrag
    @listenTo @draggy, "drop", @onDrop

  # If the view needs to reset itself when it receives new data, do it here.
  # CMS input will call trigger this method as the user changes data.
  onRefresh: ->
    super

    if @draggy
      @draggy.undelegateEvents()
      @draggy = null

    @show()

  # The user has dragged their finger on the screen. "isInitial" is true for
  # the first touch only.
  onDrag: (draggy, isInitial) ->
    @currentValue = @roundValue(draggy)
    @labelEl @getEl("knob-value"), @currentValue

    @transitionEl @getEl("knob-input"),
      if isInitial then "all 300ms" else "none"

    @offsetStrokeDash(@getEl("knob-input"), draggy.t)

  onDrop: (draggy, isReset) ->
    t = @roundPos(draggy)

    if draggy.t isnt t and not isReset
      draggy.reset({t})
    else
      @transitionEl(@getEl("knob-input"), "all 300ms")
      @offsetStrokeDash(@getEl("knob-input"), draggy.t)

      if @currentValue?
        @setState("touched")

  resetDashOffset: (path) ->
    c = @getEl("pie").offsetWidth * Math.PI
    path.style.strokeDashoffset = c
    path.style.strokeDasharray  = [c, c].join(" ")

    @circumference = c

  offsetStrokeDash: (path, t) ->
    percent = -(t - Math.PI * 2) / (Math.PI * 2)
    offset  = @circumference * percent

    path.style.strokeDashoffset = "#{offset}px"

  roundValue: (draggy) ->
    {increment, min, max} = @options.data.pie

    steps = (max - min) / increment
    step  = Math.round((draggy.t / (Math.PI * 2)) * steps)
    value = step * increment + min

    if increment < 1
      Math.round(value * 1 / increment) / (1 / increment)
    else
      value

  roundPos: (draggy) ->
    {increment, min, max} = @options.data.pie

    steps = (max - min) / increment
    step  = Math.round((draggy.t / (Math.PI * 2)) * steps)

    (Math.PI * 2) * (step / steps)

  labelEl: (el, value) ->
    {prefix, suffix} = @options.data.pie
    el.innerHTML = "#{prefix}#{value}#{suffix}"

  showAnswer: ->
    super

    @offsetStrokeDash @getEl("knob-answer"), @draggy.t
    @animateAnswerKnob(@getEl("knob-answer"))
    @draggy.lock()

  isCorrect: ->
    @currentValue is @options.data.answer.value

  animateAnswerKnob: (el) ->
    {answer, pie} = @options.data

    percent = (answer.value - pie.min) / (pie.max - pie.min)

    el.offsetWidth

    @transitionEl(el, "all 600ms")
    @offsetStrokeDash(el, percent * Math.PI * 2)

module.exports = PieChartView
