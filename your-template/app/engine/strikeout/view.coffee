# SlideView provides a lot of boilerplate, and is the super-class of all slides
# DraggyView abstracts dragging and dropping logic and fires useful events
# SmoothLine takes an array of points and returns a smoothed-out line
# Device contains useful information about the current device, including DPI
SlideView  = require("views/slide")
DraggyView = require("views/components/draggy")
SmoothLine = require("lib/draw/smooth-line")
{ dpi }    = require("lib/device")

class StrikeoutView extends SlideView
  template: require("./template")

  events:
    "iostap .btn-done": "showAnswer"

  # The serialize method is your chance to filter data on it's way from the CMS
  # to the template. Do the heavy-lifting here rather than putting the logic
  # into the jade template.
  serialize: ->
    data = super

    { title, words } = data
    title = "" if not title?

    words =
      for {replaces, incorrect}, i in words when replaces and incorrect
        title = title.replace(replaces, "{{#{i}}}")
        {replaces, incorrect}

    data.components =
      for component in title.split(" ")
        index = +component.match(/\{\{(\d+)\}\}/)?[1]
        klass: "delay-#{_.random(3)} scale-#{_.sample(["down", "up"])}"
        incorrect: words[index]?.incorrect
        replaces: words[index]?.replaces or component

    data

  # If your view has post-rendering logic that requires elements to be visible
  # in order to instantiate them properly, this is the place to do it.
  afterShow: ->
    unless @draggy
      canvas = @el.querySelector("canvas")
      canvas.width = window.innerWidth * dpi
      canvas.height = window.innerHeight * dpi

      @draggy = new DraggyView
        el: canvas
        isParent: true

      @context = @draggy.el.getContext("2d")
      @context.lineCap   = "round"

      @setEl @el.querySelectorAll(".word"), "words"

      @listenTo @draggy, "drag", @onDrag
      @listenTo @draggy, "drop", @onDrop
      @listenTo this, "resize", @onResize

      @context.clearRect(0, 0, @draggy.el.width, @draggy.el.height)
      el.classList.remove("active", "complete") for el in @getEl("words")

  # If the view needs to reset itself when it receives new data, do it here.
  # CMS input will call trigger this method as the user changes data.
  onRefresh: ->
    super

    @draggy = null
    @afterShow()

  # If the view needs to reset itself when the user resizes or rotates the
  # screen, do it here.
  onResize: ->
    @draggy.el.width = window.innerWidth * dpi
    @draggy.el.height = window.innerHeight * dpi

  # The user has dragged their finger on the screen. "isInitial" is true for
  # the first touch only.
  onDrag: (draggy, isInitial) ->
    window.clearTimeout @timeout

    if isInitial
      @line = new SmoothLine([], window.getComputedStyle(@el).color, 4 * dpi)

    @addPoint(draggy)

  # The user has finished dragging their finger on the screen. "isReset" is
  # true when draggy.reset() is called.
  onDrop: (draggy, isReset) ->
    pts = @line.getPoints()
    avgX = pts.reduce(((m, n) -> m + n.x), 0) / pts.length / dpi
    avgY = pts.reduce(((m, n) -> m + n.y), 0) / pts.length / dpi
    minX = pts.reduce(((m, n) -> if m > n.x then n.x else m), Infinity) / dpi
    maxX = pts.reduce(((m, n) -> if m < n.x then n.x else m), 0) / dpi

    for el in @getEl("words")
      bounds = el.getBoundingClientRect()
      buffer = 20

      isWithin =
        ((minX - buffer < bounds.left and maxX + buffer > bounds.right) or
        (avgX > bounds.left and avgX < bounds.right)) and
         avgY > bounds.top  and avgY < bounds.bottom

      el.classList.toggle("active", isWithin)

      if isWithin and el.dataset.replaces
        @transformEl el,
          opacity: 0
          scale: 0.8

    @removeLine()
    @showWords()
    @setState("touched")

  # Remove a point from the line until it is no more.
  removeLine: ->
    do repeat = =>
      if @line.length() > 0
        @line.remove(true)
        @drawLine()
        @timeout = window.setTimeout(repeat, 1000 / 30)

  # Show the words that have been crossed out
  showWords: ->
    window.setTimeout (=>
      for el in @getEl("words") when el.classList.contains("active")
        if replaces = el.dataset.replaces
          delete el.dataset.replaces
          el.innerHTML = replaces
          @transformEl el, { y: 0, opacity: 1 }

        el.classList.remove("active", "word-incorrect")
    ), 600

  # Add a new point to the line where the user has dragged on the screen
  addPoint: ({x, y}) ->
    @line.add x: x * dpi, y: y * dpi
    @drawLine()

  # Clear the canvas and redraw the line
  drawLine: ->
    @context.clearRect(0, 0, @draggy.el.width, @draggy.el.height)
    @line.draw(@context)

  # Let the Thomas know whether the user has got all the words
  isCorrect: ->
    (el for el in @getEl("words") when el.dataset.replaces).length is 0

module.exports = StrikeoutView
